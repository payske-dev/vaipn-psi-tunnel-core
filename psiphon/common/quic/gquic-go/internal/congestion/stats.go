package congestion

import "github.com/payske-dev/vaipn-psi-tunnel-core/psiphon/common/quic/gquic-go/internal/protocol"

type connectionStats struct {
	slowstartPacketsLost protocol.PacketNumber
	slowstartBytesLost   protocol.ByteCount
}
