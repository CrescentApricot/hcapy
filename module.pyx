# distutils: language = c++
import os

cdef extern from "hca2wav/include/clHCA.h":
    cdef cppclass clHCA:
        clHCA(unsigned int, unsigned int) except +
        int ciphKey1, ciphKey2
        void DecodeToWaveFile(const char*, const char*, float, int, int)

cdef extern from "hca2wav/main.cpp":
    cdef int atoi16(const char *s)

cdef class clHCApy:
    cdef clHCA* thisptr

    def __cinit__(self, long int ciphKey1, long int ciphKey2):
        self.thisptr = new clHCA(ciphKey1, ciphKey2)

    def __dealloc__(self):
        del self.thisptr

    def decode(self, const char* src, const char* dest, float volume=1., int mode=16, int loop=0):
        return self.thisptr.DecodeToWaveFile(src, dest, volume, mode, loop)

class Decoder:
    def __init__(self, cipher_key, cipher_key_2=None):
        if cipher_key and not cipher_key_2:
            if type(cipher_key) == str:
                if cipher_key.startswith("0x"):
                    h = cipher_key[2:].zfill(16)
                else:
                    h = cipher_key.zfill(16)
            elif type(cipher_key) == int:
                h = hex(cipher_key)[2:].zfill(16)
            else:
                raise Exception("cipher_key is must str(hex) or int.")
            self.cipher_key_1 = atoi16(h[8:].encode())
            self.cipher_key_2 = atoi16(h[:8].encode())

        elif cipher_key and cipher_key_2:
            if type(cipher_key) == int:
                self.cipher_key_1 = cipher_key
            elif type(cipher_key) == str:
                self.cipher_key_1 = atoi16(cipher_key.encode())
            else:
                raise Exception("cipher_key is must str(hex) or int.")
            if type(cipher_key_2) == int:
                self.cipher_key_2 = cipher_key_2
            elif type(cipher_key_2) == str:
                self.cipher_key_2 = atoi16(cipher_key_2.encode())
            else:
                raise Exception("cipher_key is must str(hex) or int.")
        else:
            raise Exception("cipher_key was not spec.")

        self.decoder = clHCApy(self.cipher_key_1, self.cipher_key_2)

    def decode_file(self, src: str, dest=None, volume: float=1., mode: int=16, loop: int=0):
        if dest:
            dest_e = dest.encode()
        else:
            dest_dir = os.path.dirname(src)
            src_file = os.path.basename(src)
            src_file_spl = src_file.split(".")
            if len(src_file_spl) < 0:
                dest_file = src_file + ".wav"
            else:
                src_file_spl[-1] = "wav"
                dest_file = ".".join(src_file_spl)
            dest_e = os.path.join(dest_dir, dest_file).encode()
        return self.decoder.decode(src.encode(), dest_e, volume, mode, loop)
