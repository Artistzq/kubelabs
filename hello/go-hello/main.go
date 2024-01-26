package main

import (
	"fmt"
	"net/http"
)

func helloWorld(w http.ResponseWriter, r *http.Request) {
	if r.Method == http.MethodGet && r.URL.Path == "/test" {
		w.WriteHeader(http.StatusOK)
		fmt.Fprintln(w, "hello world")
		return
	}
	http.NotFound(w, r)
}

func main() {
	http.HandleFunc("/test", helloWorld)

	// 监听并在 8080 端口启动服务
	fmt.Println("Server is listening on port 8080...")
	http.ListenAndServe("0.0.0.0:8080", nil)
}
