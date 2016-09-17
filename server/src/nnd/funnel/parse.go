package funnel

import (
	"encoding/json"
	"errors"
	"nnd/event"
)

var ErrBadLevel = errors.New("invalid level")

func Parse(payload []byte) (event *event.Event, err error) {
	err = json.Unmarshal(payload, &event)
	if err == nil && event != nil && (event.Level < 1 || event.Level > 7) {
		err = ErrBadLevel
	}
	return
}
