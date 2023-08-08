tamil_vowels = ["அ","ஆ","இ","ஈ","உ","ஊ","எ","ஏ","ஐ","ஒ","ஓ","ஔ"]
tamil_consonants = ["க","ங","ச","ஞ","ட","ண","த","ந","ப","ம","ய","ர","ல","வ","ழ","ள","ற","ன","ஜ","ஷ","ஸ","ஹ","ஶ","க்ஷ"]
tamil_vowels_symbols =["்","ா","ி","ீ","ு","ூ","ெ","ே","ை","ொ","ோ","ௌ"]

tamilto_vowels = {
    "அ":"a",
    "ஆ":"A",
    "இ":"i",
    "ஈ":"I",
    "உ":"u",
    "ஊ":"U",
    "எ":"e",
    "ஏ":"E",
    "ஐ":"ai",
    "ஒ":"o",
    "ஓ":"O",
    "ஔ":"au",
    "ா":"A",
    "ி":"i",
    "ீ":"I",
    "ு":"u",
    "ூ":"U",
    "ெ":"e",
    "ே":"E",
    "ை":"ai",
    "ொ":"o",
    "ோ":"O",
    "ௌ":"au"
    
    }

tamilto_consonants = {

    "க":"ka",
    "ங":"~Na",
    "ச":"cha",
    "ஞ":"~na",
    "ட":"Ta",
    "ண":"Na",
    "த":"tha",
    "ந":"na",
    "ப":"pa",
    "ம":"ma",
    "ய":"ya",
    "ர":"ra",
    "ல":"la",
    "வ":"va",
    "ழ":"za",
    "ள":"La",
    "ற":"Ra",
    "ன":"^na",
    "ஜ":"ja",
    "ஷ":"sha",
    "ஸ":"sa",
    "ஹ":"ha",
    "ஶ":"sya",




    }

tamil_mei_consonants = {

    "க":"k",
    "ங":"~N",
    "ச":"ch",
    "ஞ":"~n",
    "ட":"T",
    "ண":"N",
    "த":"th",
    "ந":"n",
    "ப":"p",
    "ம":"m",
    "ய":"y",
    "ர":"r",
    "ல":"l",
    "வ":"v",
    "ழ":"z",
    "ள":"L",
    "ற":"R",
    "ன":"^n",
    "ஜ":"j",
    "ஷ":"sh",
    "ஸ":"s",
    "ஹ":"h",
    "ஶ":"sy",


}



tamiltran_all = {
    **tamilto_vowels, **tamilto_consonants,
    
}


def is_vowel_tamil(ch):
    
    if ch in tamilto_vowels:
        return True
    return False


def tamiltranslate(tamil_string):

    out_str = []

    for i,cur_ch in enumerate(tamil_string[:-1]):
        
        if cur_ch in tamiltran_all:
            out_str.append(tamiltran_all[cur_ch])
        if cur_ch in tamil_vowels_symbols or cur_ch == '்':
          continue
        if tamil_string[i+1] == '்':
          out_str.pop()
          out_str.append(tamil_mei_consonants[cur_ch])
          continue
        if tamil_string[i+1] in tamil_vowels_symbols:
          out_str.pop()
          out_str.append(tamil_mei_consonants[cur_ch])
        if cur_ch == ' ' :
            out_str.append(' ')

    if tamil_string[-1] not in tamil_vowels_symbols:
        out_str.append(tamil_string[-1])
        
    else:
        out_str.append(tamiltran_all[tamil_string[-1]])
    return "".join(out_str)