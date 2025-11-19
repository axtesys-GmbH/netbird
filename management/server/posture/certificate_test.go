package posture

import (
	"context"
	"testing"

	nbpeer "github.com/netbirdio/netbird/management/server/peer"
)

func TestCertificateCheck_Check(t *testing.T) {
	// TODO: Implement certificate check tests
	check := &CertificateCheck{}

	peer := nbpeer.Peer{
		Meta: nbpeer.PeerSystemMeta{},
	}

	_, err := check.Check(context.Background(), peer)
	if err == nil {
		t.Error("Expected error for unimplemented check, got nil")
	}
}

func TestCertificateCheck_Name(t *testing.T) {
	check := &CertificateCheck{}

	if check.Name() != CertificateCheckName {
		t.Errorf("Expected check name %s, got %s", CertificateCheckName, check.Name())
	}
}

func TestCertificateCheck_Validate(t *testing.T) {
	// TODO: Implement validation tests when fields are added
	check := &CertificateCheck{}

	err := check.Validate()
	if err != nil {
		t.Errorf("Expected no validation error for empty check, got: %v", err)
	}
}
