import random
import string
import hashlib
import argparse
from tqdm import tqdm

K = [0x428a2f98, 0x71374491, 0xb5c0fbcf, 0xe9b5dba5, 0x3956c25b, 0x59f111f1, 0x923f82a4, 0xab1c5ed5,
    0xd807aa98, 0x12835b01, 0x243185be, 0x550c7dc3, 0x72be5d74, 0x80deb1fe, 0x9bdc06a7, 0xc19bf174,
    0xe49b69c1, 0xefbe4786, 0x0fc19dc6, 0x240ca1cc, 0x2de92c6f, 0x4a7484aa, 0x5cb0a9dc, 0x76f988da,
    0x983e5152, 0xa831c66d, 0xb00327c8, 0xbf597fc7, 0xc6e00bf3, 0xd5a79147, 0x06ca6351, 0x14292967,
    0x27b70a85, 0x2e1b2138, 0x4d2c6dfc, 0x53380d13, 0x650a7354, 0x766a0abb, 0x81c2c92e, 0x92722c85,
    0xa2bfe8a1, 0xa81a664b, 0xc24b8b70, 0xc76c51a3, 0xd192e819, 0xd6990624, 0xf40e3585, 0x106aa070,
    0x19a4c116, 0x1e376c08, 0x2748774c, 0x34b0bcb5, 0x391c0cb3, 0x4ed8aa4a, 0x5b9cca4f, 0x682e6ff3,
    0x748f82ee, 0x78a5636f, 0x84c87814, 0x8cc70208, 0x90befffa, 0xa4506ceb, 0xbef9a3f7, 0xc67178f2]

# Rotate Right
def rotR(a, n):
	return ((a >> n) | (a << (32 - n))) & 0xffffffff

# Shift Right
def shR(a, n):
    return a >> n

# Sigma 0
def sigma0(a):
	return (rotR(a, 7) ^ rotR(a, 18) ^ shR(a, 3)) & 0xffffffff

# Sigma 1
def sigma1(a):
	return (rotR(a, 17) ^ rotR(a, 19) ^ shR(a, 10)) & 0xffffffff

# Sum 0
def sum0(a):
    return (rotR(a, 2) ^ rotR(a, 13) ^ rotR(a, 22)) & 0xffffffff

# Sum 1
def sum1(a):
    return (rotR(a, 6) ^ rotR(a, 11) ^ rotR(a, 25)) & 0xffffffff

def ch(a, b, c):
    return ((a & b) ^ (~a & c)) & 0xffffffff

def maj(a, b, c):
    return ((a & b) ^ (a & c) ^ (b & c)) & 0xffffffff

def padding(message):
    # to binary
    paddedMessage = "".join(format(ord(ch), "08b") for ch in message)
    length = "{:064b}".format(int(len(paddedMessage)))

    # append bit 1
    paddedMessage += "1"

    # find num of block
    num_block = 0
    for i in range(1, 999999):
        if (512 * i - 64 - len(paddedMessage) > 0):
            num_block = i
            break

    # append k bit 0
    paddedMessage = paddedMessage.ljust(512 * num_block - 64, "0")

    # append 64 bit length
    paddedMessage += length

    return paddedMessage, int(len(paddedMessage) / 512)

def messageScheduler(paddedMessage, n):
    blocks = []

    for i in range(n):
        blocks.append(paddedMessage[i * 512 : (i + 1) * 512])

    W = []
    
    for i in range(n):
        print("\n================================= BLOCK: " + str(i) + "==================================")
        W.append([])
        for j in range(64):
            if (j < 16):
                W[i].append(int(blocks[i][j * 32 : (j + 1) * 32], 2))
            else:
                W[i].append((sigma1(W[i][j - 2]) + W[i][j - 7] + sigma0(W[i][j - 15]) + W[i][j - 16]) & 0xffffffff)
            print("W" + str(j).rjust(2) + ": " + "{:08x}".format(W[i][j]))
    return W

def hashComputation(W, n):
    H = [0x6a09e667, 0xbb67ae85, 0x3c6ef372, 0xa54ff53a, 0x510e527f, 0x9b05688c, 0x1f83d9ab, 0x5be0cd19]
    for i in range(n):
        print("\n================================= BLOCK: " + str(i) + "==================================")
        a, b, c, d, e, f, g, h = H[0], H[1], H[2], H[3], H[4], H[5], H[6], H[7]
        for j in range(64):
            T1 = (h + sum1(e) + ch(e, f, g) + K[j] + W[i][j]) & 0xffffffff
            T2 = (sum0(a) + maj(a, b, c)) & 0xffffffff
            h = g & 0xffffffff
            g = f & 0xffffffff
            f = e & 0xffffffff
            e = (d + T1) & 0xffffffff
            d = c & 0xffffffff
            c = b & 0xffffffff
            b = a & 0xffffffff
            a = (T1 + T2) & 0xffffffff
            print("t" + str(j).rjust(2) + ": " + "{:08x}".format(a) + " {:08x}".format(b) + " {:08x}".format(c) + " {:08x}".format(d) + " {:08x}".format(e) + " {:08x}".format(f) + " {:08x}".format(g) + " {:08x}".format(h))
        H[0] = (H[0] + a) & 0xffffffff
        H[1] = (H[1] + b) & 0xffffffff
        H[2] = (H[2] + c) & 0xffffffff
        H[3] = (H[3] + d) & 0xffffffff
        H[4] = (H[4] + e) & 0xffffffff
        H[5] = (H[5] + f) & 0xffffffff
        H[6] = (H[6] + g) & 0xffffffff
        H[7] = (H[7] + h) & 0xffffffff
    
    result = ""

    i = 0
    for h in H:
        h = h & 0xffffffff 
        print("\nH" + str(i) + ": " + "{:08x}".format(h), end='')
        result += format(h, "08x") 
        i = i + 1
    
    print("\n================================ RESULT ====================================")
    print("Result: " + result)
    return result

def checkResult(message, result):
    result_lib = hashlib.sha256(message.encode()).hexdigest()
    print("Input: " + message)
    print("Hash result:                  " + str(result))
    print("Result from standard library: " + str(result_lib))
    if result == result_lib:
        print("---> CORRECT HASH!")
    else:
        print("---> WRONG HASH!")

def SHA256_message(message):
    paddedMessage, n = padding(message)
    W = messageScheduler(paddedMessage, n)
    result = hashComputation(W, n)

    checkResult(message, result)
    return result   

def SHA256_file(file):
    # read input from the file
    messages = []
    with open(file, 'r') as f:
        for line in f:
            messages.append(str(line).replace("\n",''))
    f.close()
    print(messages)
    results = []

    # perform encryption
    for message in messages:
        print("\nInput: " + message)
        paddedMessage, n = padding(message)

        print("\n============================== Message Scheduler ==============================")
        W = messageScheduler(paddedMessage, n)

        print("\n============================== Hash Computation ==============================")
        result = hashComputation(W, n)

        results.append(result)

    # write the results into the file
    with open("result.txt", 'w') as output:
        for rs in results:
            output.write(rs + "\n")
    output.close()

    # checking the results
    print("\n================================= Cheking the results ========================================")
    for i in range(0, len(messages)):
        print("Testcase " + str(i+1) + ":")
        checkResult(messages[i], results[i])

if __name__ == "__main__":
    parser = argparse.ArgumentParser()
    parser.add_argument(
        "-m",
        "--message",
        type = str,
        default = "Digital System Design with HDL",
        help = "message to be hash",
        dest = "message"
    )
    parser.add_argument(
        "-g",
        "--gen_test_set",
        type = str,
        default = "none",
        help = "generate test set and result file, for pre-synthesis please enter pre and post for post-synthesis",
        dest = "gen_test_set"
    )

    args = parser.parse_args()

    if args.gen_test_set != "none":
        if args.gen_test_set == "pre":
            print("Generate test cases for pre-synthesis")
            numTestCases = 10000
            messagesFile = open("SourceCode/messages.txt", "w")
            resultsFile = open("SourceCode/software_results.txt", "w")
        else:
            print("Generate test cases for post-synthesis")
            numTestCases = 1000
            messagesFile = open("SourceCode/simulation/modelsim/messages.txt", "w")
            resultsFile = open("SourceCode/simulation/modelsim/software_results.txt", "w")

        for i in tqdm(range(0, numTestCases), desc = "Generating test set"):
            message = "".join(random.choice(string.ascii_lowercase + string.ascii_uppercase + string.digits) for _ in range(random.randint(1, 119)))
            result = hashlib.sha256(message.encode()).hexdigest()

            if i == numTestCases - 1:
                messagesFile.write(message)
                resultsFile.write(result)
            else:
                messagesFile.write(message + "\n")
                resultsFile.write(result + "\n")

        messagesFile.close()
    else:
        SHA256_message(args.message)
    