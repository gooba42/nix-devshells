package tests

import "testing"

func TestSample(t *testing.T) {
	if 1 != 1 {
		t.Fail()
	}
}
