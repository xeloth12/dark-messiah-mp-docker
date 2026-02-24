with open('srcds_LAA_patched.exe', 'r+b') as f:
    f.seek(0x3C)
    pe_offset = int.from_bytes(f.read(4), 'little')
    flags_offset = pe_offset + 22
    f.seek(flags_offset)
    flags = int.from_bytes(f.read(2), 'little')
    print(f'Flags before: {hex(flags)}')
    flags |= 0x20
    f.seek(flags_offset)
    f.write(flags.to_bytes(2, 'little'))
    f.seek(flags_offset)
    flags = int.from_bytes(f.read(2), 'little')
    print(f'Flags after: {hex(flags)}')
    print(f'LAA set: {bool(flags & 0x20)}')