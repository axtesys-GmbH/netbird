package posture

import (
	"context"
	"crypto/x509"
	"encoding/pem"
	"fmt"
	"os"
	"path/filepath"

	nbpeer "github.com/netbirdio/netbird/management/server/peer"
	log "github.com/sirupsen/logrus"
)

type CertificateCheck struct {
	// TODO: Add certificate check fields
}

var _ Check = (*CertificateCheck)(nil)

func (c *CertificateCheck) Check(_ context.Context, peer nbpeer.Peer) (bool, error) {
	// Meta.Certificate is a string
	certPEM := peer.Meta.Certificate
	if certPEM == "" {
		return false, fmt.Errorf("no certificate found in peer metadata")
	}
	block, _ := pem.Decode([]byte(certPEM))
	certificates, err := x509.ParseCertificates(block.Bytes)
	if err != nil {
		log.Tracef("Certificate: %v", peer.Meta.Certificate)
		return false, fmt.Errorf("failed to parse certificate: %v", err)
	}

	// There could be multiple certificates, check the first one
	cert := certificates[0]

	// if cert hostname != peer.Meta.Hostname return false
	if cert.Subject.CommonName != peer.Meta.Hostname {
		return false, fmt.Errorf("certificate common name %s does not match peer hostname %s", cert.Subject.CommonName, peer.Meta.Hostname)
	}

	// read /var/lib/netbird/ca.pem file and parse it
	caPem, err := os.ReadFile(filepath.Join("/var/lib/netbird", "ca.pem"))

	block, _ = pem.Decode(caPem)

	if err != nil {
		return false, fmt.Errorf("failed to read CA certificate: %v", err)
	}

	caCerts, err := x509.ParseCertificates(block.Bytes)
	if err != nil {
		return false, fmt.Errorf("failed to parse CA certificate: %v", err)
	}

	// create a CertPool and add the CA certificate
	roots := x509.NewCertPool()
	for _, caCert := range caCerts {
		roots.AddCert(caCert)
	}

	opts := x509.VerifyOptions{
		Roots: roots,
	}

	if _, err := cert.Verify(opts); err != nil {
		return false, fmt.Errorf("failed to verify certificate: %v", err)
	}

	return true, nil
}

func (c *CertificateCheck) Name() string {
	return CertificateCheckName
}

func (c *CertificateCheck) Validate() error {
	// TODO: Implement certificate check validation
	return nil
}
