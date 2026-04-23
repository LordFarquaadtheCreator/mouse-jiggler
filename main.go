package main

/*
#cgo LDFLAGS: -framework CoreGraphics
#include <CoreGraphics/CoreGraphics.h>

static inline CGEventSourceRef nullEventSource() { return NULL; }
static inline CGEventRef nullEvent() { return NULL; }
*/
import "C"

import (
	"fmt"
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
		fmt.Println("\nExiting...")
		os.Exit(0)
	}()

	fmt.Println("Mouse jiggler running. Ctrl+C to exit.")

	movements := []int{2, 4, 8, 16}
	ticker := time.NewTicker(1 * time.Second)
	defer ticker.Stop()

	for range ticker.C {
		dx := movements[rand.Intn(4)]
		dy := movements[rand.Intn(4)]
		jiggle(dx, dy)
	}
}

func jiggle(dx, dy int) {
	event := C.CGEventCreate(C.nullEventSource())
	if event == C.nullEvent() {
		return
	}
	defer C.CFRelease(C.CFTypeRef(event))

	pt := C.CGEventGetLocation(event)
	pt.x += C.double(dx)
	pt.y += C.double(dy)

	moveEvent := C.CGEventCreateMouseEvent(C.nullEventSource(), C.kCGEventMouseMoved, pt, 0)
	if moveEvent == C.nullEvent() {
		return
	}
	defer C.CFRelease(C.CFTypeRef(moveEvent))

	C.CGEventPost(C.kCGHIDEventTap, moveEvent)
}
