package posture

import (
	"context"
	"fmt"

	nbpeer "github.com/netbirdio/netbird/management/server/peer"
)

type CertificateCheck struct {
	// TODO: Add certificate check fields
}

var _ Check = (*CertificateCheck)(nil)

func (c *CertificateCheck) Check(_ context.Context, peer nbpeer.Peer) (bool, error) {
	// TODO: Implement certificate check logic
	return false, fmt.Errorf("certificate check not implemented")
}

func (c *CertificateCheck) Name() string {
	return CertificateCheckName
}

func (c *CertificateCheck) Validate() error {
	// TODO: Implement certificate check validation
	return nil
}
