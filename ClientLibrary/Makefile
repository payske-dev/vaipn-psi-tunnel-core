shared:
	go build -buildmode=c-shared -o libvaipntunnel.so VaipnTunnel.go
.PHONY: shared

static:
	go build -buildmode=c-archive -o libvaipntunnel.a VaipnTunnel.go

clean:
	rm libvaipntunnel.so libvaipntunnel.h

.PHONY: static
