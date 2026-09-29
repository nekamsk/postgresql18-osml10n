/*

Thai to Latin transcription code via Thai language processing package
https://pypi.org/project/tltk/

Hopefully using Royal Thai General System of Transcription (RTGS)

(c) 2018-2019 Sven Geggus <svn-osm@geggus.net>

*/

CREATE OR REPLACE FUNCTION osml10n_thai_transcript(inpstr text) RETURNS TEXT AS $$
  import unicodedata
  import plpy

  def split_by_alphabet(str):
    strlist=[]
    target=''
    oldalphabet=unicodedata.name(str[0]).split(' ')[0]
    target=str[0]
    for c in str[1:]:
      alphabet=unicodedata.name(c).split(' ')[0]
      if (alphabet==oldalphabet):
        target=target+c
      else:
        strlist.append(target)
        target=c
      oldalphabet=alphabet
    strlist.append(target)
    return(strlist)

  def romanize_word(w):
    r = tltk.nlp.th2roman(w)
    for marker in ('<s/>', '<s>', '</s>'):
      r = r.replace(marker, ' ')
    return r.strip()

  try:
    import tltk
  except:
    plpy.notice("tltk not installed, falling back to ICU")
    return(None)

  stlist=split_by_alphabet(inpstr)

  latin = ''
  for st in stlist:
    if (unicodedata.name(st[0]).split(' ')[0] == 'THAI'):
      try:
        seg = tltk.nlp.word_segment(st)
        # word_segment возвращает строку вида 'слово1|слово2|<s/>'
        if isinstance(seg, str):
          words = seg.split('|')
        else:
          words = list(seg)
        # фильтруем маркеры и пустые токены
        parts = []
        for w in words:
          w = w.strip()
          if not w or w.startswith('<'):
            continue
          # оставляем только токены, начинающиеся с тайского символа
          if unicodedata.name(w[0]).split(' ')[0] != 'THAI':
            continue
          r = romanize_word(w)
          if r:
            parts.append(r)
        transcript = ' '.join(parts)
      except Exception as e:
        plpy.notice("tltk error transcribing >%s<: %s" % (st, e))
        return(None)
      latin = latin + transcript
    else:
      latin = latin + st
  return(latin)
$$ LANGUAGE plpython3u STABLE;
