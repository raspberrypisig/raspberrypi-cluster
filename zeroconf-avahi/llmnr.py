#!/usr/bin/env python3
import socket
from pathlib import Path
from time import sleep

sleep(60)

ANY = "0.0.0.0"
MCAST_ADDR = "224.0.0.252"
MCAST_PORT = 5355

# Create a UDP socket
sock = socket.socket(socket.AF_INET, socket.SOCK_DGRAM, socket.IPPROTO_UDP)

# Allow multiple sockets to use the same PORT number
sock.setsockopt(socket.SOL_SOCKET,socket.SO_REUSEADDR,1)

# Bind to the port that we know will receive multicast data
sock.bind((ANY,MCAST_PORT))

# Tell the kernel that we want to add ourselves to a multicast group
# The address for the multicast group is the third param
status = sock.setsockopt(socket.IPPROTO_IP,
socket.IP_ADD_MEMBERSHIP,
socket.inet_aton(MCAST_ADDR) + socket.inet_aton(ANY))

# setblocking(0) is equiv to settimeout(0.0) which means we poll the socket.
# But this will raise an error if recv() or send() can't immediately find or send data.
sock.setblocking(0)

def parseHostname(data):
    nameLen = data[12]
    #print(nameLen)
    return data[13:13+nameLen]

while 1:
    try:
        data, addr = sock.recvfrom(1024)
        hn = parseHostname(data)
        if str(hn).find('k3smaster') == -1:
            continue
        #print(hn)
        #subdomains = Path('/etc/llmnr/SUBDOMAINS_K3SMASTER').read_text().split('\n')
        #if '' in subdomains:
        #    subdomains.remove('')
        #subdomains = subdomains + ["k3smaster"]
        #boo=[str(hn).find(i)!=-1 for i in subdomains]
        #if True in boo or str(hn) == "k3smaster":
        #    pass
        #else:
        #    continue
    except socket.error as e:
        pass
    else:
        hostname_length = data[12]
        record_type = hex(data[12 + hostname_length + 3])
        data_response = bytearray(data)
        data_response[2] = 0x80
        data_response[7] = 0x01
        hostname = bytearray(data[12: 12 + hostname_length + 6])
        answer_header = b'\x00\x00\x00\x1e\x00\x04'
        IP = socket.gethostbyname('k3smaster.local')
        ip_octals = bytearray(map(int, IP.split('.')))
        #print(type(record_type))
        if record_type == "0x1":
            #print("From: ", addr)
            #print("Data: ", data)
            #print("TransactionID: ", data[0:2])
            #print("recordtype(hex): ", hex(data[12 + hostname_length + 3]))
            response = data_response + hostname + answer_header + ip_octals
            #print("response: ", data_response + hostname + answer_header + ip_octals)
            sock.sendto(response,addr)
