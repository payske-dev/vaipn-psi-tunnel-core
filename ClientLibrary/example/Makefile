main: libvaipntunnel.so main.o
	gcc -I. -o main main.o -L. -lvaipntunnel

main.o: main.c
	gcc -I.. -c main.c

libvaipntunnel.so: ../VaipnTunnel.go
	go build -buildmode=c-shared -o libvaipntunnel.so ../VaipnTunnel.go

clean:
	rm libvaipntunnel.so libvaipntunnel.h main main.o

