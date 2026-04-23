package main

/*
#cgo LDFLAGS: -framework CoreGraphics
#include <CoreGraphics/CoreGraphics.h>

static inline CGEventSourceRef nullEventSource() { return NULL; }
static inline CGEventRef nullEvent() { return NULL; }
*/
import "C"

import (
	"log"
	"math/rand"
	"os"
	"os/signal"
	"syscall"
	"time"
)

func main() {
	c := make(chan os.Signal, 1)
	signal.Notify(c, os.Interrupt, syscall.SIGTERM)
	go func() {
		<-c
		log.Println("Exiting...")
		os.Exit(0)
	}()

	log.Println("Mouse jiggler running. Ctrl+C to exit.")

	movements := []int{2, 4, 8, 16}
	ticker := time.NewTicker(1 * time.Second)
	defer ticker.Stop()

	for range ticker.C {
		dx := movements[rand.Intn(4)]
		dy := movements[rand.Intn(4)]
		if err := jiggle(dx, dy); err != nil {
			log.Printf("jiggle failed: %v", err)
		}
	}
}

func jiggle(dx, dy int) error {
	event := C.CGEventCreate(C.nullEventSource())
	if event == C.nullEvent() {
		return log.Output(2, "CGEventCreate returned nil")
	}
	defer C.CFRelease(C.CFTypeRef(event))

	pt := C.CGEventGetLocation(event)
	newX := pt.x + C.double(dx)
	newY := pt.y + C.double(dy)

	moveEvent := C.CGEventCreateMouseEvent(C.nullEventSource(), C.kCGEventMouseMoved, C.CGPoint{x: newX, y: newY}, 0)
	if moveEvent == C.nullEvent() {
		return log.Output(2, "CGEventCreateMouseEvent returned nil")
	}
	defer C.CFRelease(C.CFTypeRef(moveEvent))

	C.CGEventPost(C.kCGHIDEventTap, moveEvent)
	log.Printf("moved mouse to (%.0f, %.0f)", newX, newY)
	return nil
}
