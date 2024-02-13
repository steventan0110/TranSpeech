import argparse
import glob
import os
import soundfile


def get_parser():
    parser = argparse.ArgumentParser()
    parser.add_argument("--manifest", type=str, help="path to manifest file")
    parser.add_argument(
        "--file", type=str, metavar="DIR", help="output directory"
    )
    return parser

def main(args):
    file_to_check = args.file
    with open(args.manifest, "r") as f:
        for line in f:
            file_id = line.strip().split("|")[0]
            if "common_voice_fr_196444" in file_id:
                print(line)
                print(file_id)


            if file_to_check in file_id:
                print(f"Found {args.file} in manifest")
                return

    print(f"Did not find {args.file} in manifest")


if __name__ == "__main__":
    parser = get_parser()
    args = parser.parse_args()
    main(args)
