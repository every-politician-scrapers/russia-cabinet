const fs = require('fs');
let rawmeta = fs.readFileSync('meta.json');
let meta = JSON.parse(rawmeta);

module.exports = (id, label, startdate, enddate) => {
  qualifier = { }
  if(meta.term) qualifier['P2937'] = meta.term
  if(startdate) qualifier['P580']  = startdate
  if(enddate)   qualifier['P582']  = enddate

  reference = {}
  if(meta.source) {
    var wpref = /wikipedia.org/;
    if (wpref.test(meta.source)) {
      reference['P4656'] = meta.source
    } else {
      reference['P854'] = meta.source
    }
  }
  reference['P813'] = new Date().toISOString().split('T')[0]
  reference['P1810'] = label

  return {
    id,
    claims: {
      P39: {
        value: meta.position,
        qualifiers: qualifier,
        references: reference,
      }
    }
  }
}
