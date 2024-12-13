package utils

import "github.com/payske-dev/vaipn-psi-tunnel-core/psiphon/common/quic/gquic-go/internal/protocol"

// PacketInterval is an interval from one PacketNumber to the other
type PacketInterval struct {
	Start protocol.PacketNumber
	End   protocol.PacketNumber
}
