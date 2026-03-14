import serial
import sys
import threading

def read_from_uart(ser):
    while True:
        if ser.in_waiting > 0:
            data = ser.read(ser.in_waiting).decode("utf-8", errors="replace")
            print(data, end="", flush=True)

port = sys.argv[1] if len(sys.argv) > 1 else "/dev/ttyACM0"

try:
    ser = serial.Serial(port, baudrate=115200, timeout=0.1)
except Exception as e:
    print(f"Failed to open port {port}: {e}")
    sys.exit(1)

threading.Thread(target=read_from_uart, args=(ser,), daemon=True).start()

print(f"Connected to {port}. Type your message and press Enter:")

try:
    while True:
        user_input = sys.stdin.readline().strip()

        msg = (user_input + "\r\n").encode("utf-8")
        buffer = msg.ljust(64, b"\x00")[:64]

        ser.write(buffer)
except KeyboardInterrupt:
    print("\nExiting...")
finally:
    ser.close()

