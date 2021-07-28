module.exports = (id, position, personname, positionname, startdate) => {
  reference = {
    P854: 'http://government.ru/en/gov/persons/',
    P1476: {
      text: 'Senior Russian Government Officials',
      language: 'en',
    },
    P813: new Date().toISOString().split('T')[0],
    P407: 'Q1860', // language: English
  }

  qualifier = {
    P580: '2020-01-21',
    P5054: 'Q82455849', // Mikhail Mishustin's Cabinet
  }

  if(startdate)      qualifier['P580']  = startdate
  if(personname)     reference['P1810'] = personname
  if(positionname)   reference['P1932'] = positionname

  return {
    id,
    claims: {
      P39: {
        value: position,
        qualifiers: qualifier,
        references: reference,
      }
    }
  }
}
