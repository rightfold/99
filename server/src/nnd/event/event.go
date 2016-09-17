package event

import "time"

type Event struct {
	Log       string
	Timestamp time.Time
	Host      string
	Level     Level
	Fields    map[string]string
}

type Level int

const (
	DEBUG    Level = 7
	INFO     Level = 6
	NOTICE   Level = 5
	WARNING  Level = 4
	ERROR    Level = 3
	CRITICAL Level = 2
	ALERT    Level = 1
)
