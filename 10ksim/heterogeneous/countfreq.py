import itertools

def readfq(fp): # this is a generator function
    last = None # this is a buffer keeping the last unprocessed line
    while True: # mimic closure; is it a bad idea?
        if not last: # the first record or a record following a fastq
            for l in fp: # search for the start of the next record
                if l[0] in '>@': # fasta/q header line
                    last = l[:-1] # save this line
                    break
        if not last: break
        name, seqs, last = last[1:].partition(" ")[0], [], None
        for l in fp: # read the sequence
            if l[0] in '@+>':
                last = l[:-1]
                break
            seqs.append(l[:-1])
        if not last or last[0] != '+': # this is a fasta record
            yield name, ''.join(seqs), None # yield a fasta record
            if not last: break
        else: # this is a fastq record
            seq, leng, seqs = ''.join(seqs), 0, []
            for l in fp: # read the quality
                seqs.append(l[:-1])
                leng += len(l) - 1
                if leng >= len(seq): # have read enough quality
                    last = None
                    yield name, seq, ''.join(seqs); # yield a fastq record
                    break
            if last: # reach EOF before reading enough quality
                yield name, seq, None # yield a fasta record instead
                break


if __name__ == "__main__":
    import sys
    y=list(map(lambda x: "".join(x), itertools.product(['A','T','G','C'],['A','T','G','C'],['A','T','G','C']))) + ["---"]
    mp = dict(zip(y,[0]*65))
    n, slen, qlen = 0, 0, 0
    for name, seq, qual in readfq(sys.stdin):
        for k in [seq[i:i+3] for i in range(0, len(seq), 3)]:
            if k in mp:
                mp[k] += 1
    tot = 0
    for i in ['T', 'C', 'A', 'G']:
        for j in ['T', 'C', 'A', 'G']:
            for k in ['T', 'C', 'A', 'G']:
                code = i+j+k
                if code not in ['TAA', 'TAG', 'TGA']:
                    tot += mp[code]

    print("\t[statefreq]")
    for i in ['T', 'C', 'A', 'G']:
        for j in ['T', 'C', 'A', 'G']:
            sys.stdout.write("\t")
            for k in ['T', 'C', 'A', 'G']:
                code = i+j+k
                if code not in ['TAA', 'TAG', 'TGA']:
                    sys.stdout.write(str(mp[code]/tot) + " ")
                else:
                    sys.stdout.write("0 ")
            sys.stdout.write("\n")
        sys.stdout.write("\n")
       

