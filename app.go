package main

import (
	"fmt"
	"io"
	"net/http"
	"os"

	"github.com/otiai10/gosseract/v2"
)

const DefaultUrl string = "https://d2kbvjszk9d5ln.cloudfront.net/yshop/upload/pic/copy-text-from-images-20230803064150649.png"

func main() {
	client := gosseract.NewClient()
	defer client.Close()

	imgUrl := DefaultUrl
	if len(os.Args) > 2 && os.Args[1] == "--url" {
		fmt.Println("use image from args")
		imgUrl = os.Args[2]
	}
	rep, err := http.Get(imgUrl)
	if err != nil {
		fmt.Errorf("failed to fetch img url %d", rep.StatusCode)
		return
	}
	defer rep.Body.Close()

	imageBytes, _ := io.ReadAll(rep.Body)

	client.SetImageFromBytes(imageBytes)
	text, _ := client.Text()
	fmt.Printf("output: %s \n", text)
}
