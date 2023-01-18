import re
import sys
import random
import string

import pandas as pd


bengali_vowels = ["অ", "আ", "ই", "ঈ", "উ", "ঊ", "এ", "ঐ", "ও", "ঔ"]
bengali_sonorants = ["ঋ", "ৠ", "ऌ", "ঌ", "ৡ"]
bengali_anuswara = ["अं"]
bengali_nukta = ["़"]
bengali_consonants = [
    "ক", "খ", "গ", "ঘ", "ঙ",
    "চ", "ছ", "জ", "ঝ", "ঞ",
    "ট", "ঠ", "ড", "ঢ", "ণ",
    "ত", "থ", "দ", "ধ", "ন",
    "প", "ফ", "ব", "ভ", "ম",
    "য", "র", "ল", "ব",
    "শ", "ষ", "স", "হ"
]
"""
print("Roman characters")
roman_chars = string.ascii_letters[:26]
for i, roman_char in enumerate(roman_chars):
    print((roman_char, len(roman_char.encode('utf8'))), end=" ")
    if (i+1)%10 == 0:
        print()
print()

print("\nBenagli characters")
devanagari_chars = hin_vowels + hin_sonorants + hin_anuswara + hin_consonants
for i, devanagari_char in enumerate(devanagari_chars):
    print((devanagari_char, len(devanagari_char.encode('utf8'))), end=" ")
    if (i+1)%10 == 0:
        print()
print()
"""
bengali2itran_vowels = {
    "অ": "a",
    "আ": "A",
    "ই": "i",
    "ঈ": "I",
    "উ": "u",
    "ঊ": "uu",
    "এ": "e",
    "ঐ": "ai",
    "ও": "o",
    "ঔ": "au",
    "ঃ": "H",
    "ি": "i",
    "া": "A",
    "ে": "e",
    "ু": "u",
    "ো": "o",
    "ী": "ii",
    "ং": ".n",
    "ূ": "U",
    "ৈ": "ai",
    "ৃ": "RRi",
    "ৄ": "RRI",
    "ৌ": "au",
    "্": "",
    "ঁ": ".N",
    "়": ""
}
bengali2itran_sonorants = {
    "ঋ": "RRi",
    "ৠ": "RRI",
    "ঌ": "LLi",
    "ৡ": "LLI",
}
bengali2itran_anuswara = {"ওঁ": "OM", " ঁ": ".N"}
bengali2itran_consonants = {
    "ক": "k",
    "খ": "kh",
    "গ": "g",
    "ঘ": "gh",
    "ঙ": "N",
    "চ": "ch",
    "ছ": "C",
    "জ": "j",
    "ঝ": "jh",
    "ঞ": "n",
    "ট": "T",
    "ঠ": "Th",
    "ড": "D",
    "ঢ": "Dh",
    "ণ": "N",
    "ত": "t",
    "থ": "th",
    "দ": "d",
    "ধ": "dh",
    "ন": "n",
    "প": "p",
    "ফ": "ph",
    "ব": "b",
    "ভ": "bh",
    "ম": "m",
    "য": "y",
    "র": "r",
    "ল": "l",
    "শ": "sh",
    "ষ": "sh",
    "স": "s",
    "হ": "h",
    "ড়": ".Da",
    "ড়": ".Da",
    "ঢ়": ".Dha",
    "ক্ষ": "x",
    "জ্ঞ": "GY",
    "শ্র": "shr",
    "য়": "Y",
    "ৎ": "t.h",
    "০": "0",
    "১": "1",
    "২": "2",
    "৩": "3",
    "৪": "4",
    "৫": "5",
    "৬": "6",
    "৭": "7",
    "৮": "8",
    "৯": "9",
}


bengali2itran_all = {
    **bengali2itran_vowels, **bengali2itran_anuswara,
    **bengali2itran_sonorants, **bengali2itran_consonants,
    
}

def is_vowel_bengali(char):
    """
    Checks if the character is a vowel.
    """
    if char in bengali2itran_anuswara or char in bengali2itran_vowels:
        return True
    return False


def bengali2itran(bengali_string):
    """
    Converts the Hindi string to the WX string.

    This function goes through each character from the hin_string and
    maps it to a corresponding Roman character according to the
    Devanagari to Roman character mapping defined previously.
    """
    itran_string = []
    for i, current_char in enumerate(bengali_string[:-1]):
        # skipping over the character as it's not included
        # in the mapping
        if current_char == "‍্":
            continue

      
        # get the Roman character for the Devanagari character
        if current_char in bengali2itran_all:
            itran_string.append(bengali2itran_all[current_char])
        else:
            itran_string.append(current_char)    

        # Handling of "a" sound after a consonant if the next
        # character is not "्" which makes the previous character half

        if not is_vowel_bengali(current_char):
            if bengali_string[i+1] != "‍্" and not is_vowel_bengali(bengali_string[i+1]):
                itran_string.append(bengali2itran_all["অ"])
    if is_vowel_bengali(bengali_string[-1]):
        itran_string.append(bengali2itran_all[bengali_string[-1]])
    if not is_vowel_bengali(bengali_string[-1]):
        itran_string.append(bengali2itran_all["অ"])
    if bengali_string[-1] not in bengali2itran_all:
        itran_string.append(bengali_string[-1])    
    itran_string = "".join(itran_string)

    # consonant + anuswara should be replaced by
    # consonant + "a" sound + anuswara
    reg1 = re.compile("([kKgGfcCjJFtTdDNwWxXnpPbBmyrlvSRsh])M")
    itran_string = reg1.sub("\g<1>aM", itran_string)

    return itran_string


pairs = [
    ("বললো", "bollo"),
    ("আমাকে", "aamake"),
    ("মী", "mii"),
    ("চুপ", "chup"),
    ("আমার", "aamaara")
]

# test_df = pd.DataFrame(pairs, columns=["Hindi String", "Actual WX"])
# test_df["Our WX"] = test_df["Hindi String"].apply(hin2wx)
# test_df["Both WX eq?"] = test_df["Actual WX"] == test_df["Our WX"]
# test_df.index = test_df.index + 1
# print(test_df)


test_df = pd.read_csv('/content/bengalitext', sep="\n", header=None)
test_df.columns = ["Bengali String"]

tf = pd.DataFrame(columns=['Bengali String'])
for i,line in enumerate(test_df['Bengali String']):
  val = []
  arr = line.split()
  val = [bengali2itran(x) for x in arr]
  tf.loc[i] = " ".join(val)


import csv

txt_file = '/content/out'
open(txt_file, 'w').close()
with open(txt_file, "w") as my_output_file:
        [ my_output_file.write(row+'\n') for row in tf['Bengali String']]
my_output_file.close()