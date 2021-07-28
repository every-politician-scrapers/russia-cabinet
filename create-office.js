// wd create-entity create-office.js "Minister for X"
module.exports = (label) => {
  return {
    type: 'item',
    labels: {
      en: label,
    },
    descriptions: {
      en: 'Russian government position',
    },
    claims: {
      P31:   { value: 'Q294414' }, // instance of: public office
      P279:  { value: 'Q83307'  }, // subclas of: minister
      P17:   { value: 'Q159'    }, // country: Russia
      P1001: { value: 'Q159'    }, // jurisdiction: Russia
      P361: {
        value: 'Q1140115',         // part of: Government of Russia
        references: {
          P854: 'http://government.ru/en/gov/persons/'
        },
      }
    }
  }
}
