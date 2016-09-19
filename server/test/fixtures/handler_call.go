package handlers

import (
	"io/ioutil"
	"nnd/context"
	"nnd/event"
)

func TempHandler(context *context.Context, event *event.Event) error {
	return ioutil.WriteFile("/tmp/99d_test_handler_call", []byte("called"), 0777)
}
