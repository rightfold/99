package funnel

import (
	"encoding/json"
	"errors"
	"nnd/event"
)

// ErrBadLevel is returned when a level is out of range.
var ErrBadLevel = errors.New("invalid level")

// Parse parses an event from a packet.
func Parse(payload []byte) (event *event.Event, err error) {
	err = json.Unmarshal(payload, &event)
	if err == nil && event != nil && (event.Level < 1 || event.Level > 7) {
		err = ErrBadLevel
	}
	return
}
