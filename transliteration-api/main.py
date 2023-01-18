import json

from flask import Flask, request, jsonify

app = Flask(__name__)

class Scheme(dict):
    def __init__(self, data=None, is_roman=True, name=None):
        super(Scheme, self).__init__(data)
        self.is_roman = is_roman
        self.name = name


class ItransScheme(Scheme):
    def __init__(self):
        super(ItransScheme, self).__init__({
            'vowels': str.split("""a A i I u U RRi RRI LLi LLI e ai o au e o"""),
            'marks': str.split("""A i I u U RRi RRI LLi LLI e ai o au e o"""),
            'virama': [''],
            'yogavaahas': str.split('M H N'),
            'consonants': str.split("""
                            k kh g gh ~N
                            ch Ch j jh ~n
                            T Th D Dh N
                            t th d dh n
                            p ph b bh m
                            y r l v
                            sh Sh s h
                            L kSh j~n
                            """)
                          + str.split("""na ra zh q K G z .D .Dh f ya"""),
            'symbols': str.split("""
                       OM .a | ||
                       0 1 2 3 4 5 6 7 8 9
                       """)
        }, name='itrans')


class BrahmicScheme(Scheme):

    def __init__(self, data=None, name=None):
        super(BrahmicScheme, self).__init__(data=data, name=name, is_roman=False)
        self.vowel_to_mark_map = dict(zip(self["vowels"], [""] + self["marks"]))


class TeluguScheme(BrahmicScheme):
    def __init__(self):
        super(TeluguScheme, self).__init__({
            'vowels': str.split("""అ ఆ ఇ ఈ ఉ ఊ ఋ ౠ ఌ ౡ ఏ ఐ ఓ ఔ ఎ ఒ"""),
            'marks': str.split("""ా ి ీ ు ూ ృ ౄ ౢ ౣ ే ై ో ౌ ె  ొ"""),
            'virama': str.split('్'),
            'yogavaahas': str.split('ం ః ఁ'),
            'consonants': str.split("""
                            క ఖ గ ఘ ఙ
                            చ ఛ జ ఝ ఞ
                            ట ఠ డ ఢ ణ
                            త థ ద ధ న
                            ప ఫ బ భ మ
                            య ర ల వ
                            శ ష స హ
                            ళ క్ష జ్ఞ
                            """)
                          + str.split("""ऩ ఱ ఴ क़ ఖ ग़ ज़ ड़ ఢ ఫ य़"""),
            'symbols': str.split("""
                       ఓం ఽ । ॥
                       ౦ ౧ ౨ ౩ ౪ ౫ ౬ ౭ ౮ ౯
                       """)
        }, name='telugu')


class GujaratiScheme(BrahmicScheme):
    def __init__(self):
        super(GujaratiScheme, self).__init__({
            'vowels': str.split("""અ આ ઇ ઈ ઉ ઊ ઋ ૠ ઌ ૡ એ ઐ ઓ ઔ"""),
            'marks': str.split("""ા િ ી ુ ૂ ૃ ૄ ૢ ૣ ે ૈ ો ૌ"""),
            'virama': str.split('્'),
            'yogavaahas': str.split('ં ઃ ઁ ᳵ ᳶ ઼'),
            'consonants': str.split("""
                            ક ખ ગ ઘ ઙ
                            ચ છ જ ઝ ઞ
                            ટ ઠ ડ ઢ ણ
                            ત થ દ ધ ન
                            પ ફ બ ભ મ
                            ય ર લ વ
                            શ ષ સ હ
                            ળ ક્ષ જ્ઞ
                            """)
                          + str.split("""ન઼ ર઼ ળ઼ ક઼ ખ઼ ગ઼ જ઼ ડ઼ ઢ઼ ફ઼ ય઼"""),
            'symbols': str.split("""
                       ૐ ઽ । ॥
                       ૦ ૧ ૨ ૩ ૪ ૫ ૬ ૭ ૮ ૯
                       """)
        }, name='gujarati')


class BengaliScheme(BrahmicScheme):
    def __init__(self):
        super(BengaliScheme, self).__init__({
            'vowels': str.split("""অ আ ই ঈ উ ঊ ঋ ৠ ঌ ৡ এ ঐ ও ঔ"""),
            'marks': str.split("""া ি ী ু ূ ৃ ৄ ৢ ৣ ে ৈ ো ৌ"""),
            'virama': str.split('্'),
            'yogavaahas': str.split('ং ঃ ঁ ᳵ ᳶ ়'),
            'consonants': str.split("""
                            ক খ গ ঘ ঙ
                            চ ছ জ ঝ ঞ
                            ট ঠ ড ঢ ণ
                            ত থ দ ধ ন
                            প ফ ব ভ ম
                            য র ল ব
                            শ ষ স হ
                            ळ ক্ষ জ্ঞ 
                            """)
                          + str.split("""ন় র় ষ় ক় খ় গ় জ় ড় ঢ় ফ় য়"""),
            'symbols': str.split("""
                       ॐ ঽ । ॥
                       ০ ১ ২ ৩ ৪ ৫ ৬ ৭ ৮ ৯
                       """)
        }, name='bengali')


SCHEMES = {
    'BENGALI': BengaliScheme(),
    'GUJARATI': GujaratiScheme(),
    'TELUGU': TeluguScheme(),
    'ITRANS': ItransScheme()
}


class SchemeMap(object):

    def __init__(self, from_scheme, to_scheme):

        self.marks = {}
        self.virama = {}

        self.vowels = {}
        self.consonants = {}
        self.non_marks_viraama = {}
        self.from_scheme = from_scheme
        self.to_scheme = to_scheme
        self.max_key_length_from_scheme = max(len(x) for g in from_scheme
                                              for x in from_scheme[g])

        for group in from_scheme.keys():
            if group not in to_scheme.keys():
                continue
            conjunct_map = {}
            for (k, v) in zip(from_scheme[group], to_scheme[group]):
                conjunct_map[k] = v
            if group.endswith('marks'):
                self.marks.update(conjunct_map)
            elif group == 'virama':
                self.virama = conjunct_map
            else:
                self.non_marks_viraama.update(conjunct_map)
                if group.endswith('consonants'):
                    self.consonants.update(conjunct_map)
                elif group.endswith('vowels'):
                    self.vowels.update(conjunct_map)


def transliterate(data, _from, _to):
    scheme_map = SchemeMap(SCHEMES[_from], SCHEMES[_to])
    marks = scheme_map.marks
    virama = scheme_map.virama
    consonants = scheme_map.consonants
    non_marks_viraama = scheme_map.non_marks_viraama
    to_roman = scheme_map.to_scheme.is_roman
    max_key_length_from_scheme = scheme_map.max_key_length_from_scheme

    buf = []
    i = 0
    to_roman_had_consonant = found = False
    append = buf.append

    while i <= len(data):

        token = data[i:i + max_key_length_from_scheme]
        while token:

            if len(token) == 1:
                if token in marks:
                    append(marks[token])
                    found = True
                elif token in virama:
                    append(virama[token])
                    found = True
                else:
                    if to_roman_had_consonant:
                        append('a')
                    append(non_marks_viraama.get(token, token))
                    found = True
            else:
                if token in non_marks_viraama:
                    if to_roman_had_consonant:
                        append('a')
                    append(non_marks_viraama.get(token))
                    found = True

            if found:
                to_roman_had_consonant = to_roman and token in consonants
                i += len(token)
                break
            else:
                token = token[:-1]

        if not found:
            if i < len(data):
                append(data[i])
                to_roman_had_consonant = False
            i += 1

        found = False

    if to_roman_had_consonant:
        append('a')
    return ''.join(buf).lower()


@app.route('/api', methods= ['POST'])
def response():
    request_data = request.get_json()
    language = request_data['language']
    text = request_data['original_text']

    if language == "Gujarati":
        new_text = transliterate(text, _from='GUJARATI', _to='ITRANS')
        return jsonify({'language': language, 'transliterated_text': new_text})
    elif language == "Bengali":
        new_text = transliterate(text, _from='BENGALI', _to='ITRANS')
        return jsonify({'language': language, 'transliterated_text': new_text})
    elif language == "Telugu":
        new_text = transliterate(text, _from='TELUGU', _to='ITRANS')
        return jsonify({'language': language, 'transliterated_text': new_text})

@app.route('/')
def index():
    return "<h1>This is a transliteration api</h1>"

if __name__ == '__main__':
    app.run(threaded=True)
