# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

User.create! email: 'admin@websites-smart.de', password: 'password', role: 'admin'

Subject.create! name: 'Mathe'
Subject.create! name: 'Englisch'
Subject.create! name: 'Bio'
Subject.create! name: 'Technik'

Product.create! title: 'Englisch', subtitle: 'inkl. Hörverstehensdateien in mp3', description: 'Prüfungsaufgaben mit Lösungen der Jahrgänge 2009-2015.', price: '9.80', reduced_price: '8', year: '2016', image: '/assets/images/books/Englisch_2016.jpg', weight: '0'

Product.create! title: 'Deutsch', subtitle: 'Prüfungsaufgaben mit Lösungsvorschläge und Übungsbausteine 2015', description: 'Prüfungsaufgaben mit Lösungen der Jahrgänge 2009-2015.', price: '9.80', reduced_price: '8', year: '2016', image: '/assets/images/books/Deutsch_2016.jpg', weight: '0'
Product.create! title: 'Wirtschaft', subtitle: 'Prüfungsaufgaben mit Lösungen 2009 - 2015', description: 'Prüfungsaufgaben mit Lösungen der Jahrgänge 2009-2015.', price: '11.80', reduced_price: '10', year: '2016', image: '/assets/images/books/Wirtschaft_2016.jpg', weight: '0'
Product.create! title: 'Technische Physik', subtitle: 'Prüfungsaufgaben mit Lösungen 2009 - 2015', description: 'Prüfungsaufgaben mit Lösungen der Jahrgänge 2009-2015.', price: '11.80', reduced_price: '10', year: '2016', image: '/assets/images/books/Technische_Physik_2016.jpg', weight: '0'
Product.create! title: 'Biologie mit Gesundheitslehre', subtitle: 'Prüfungsaufgaben mit Lösungen 2009 - 2015', description: 'Prüfungsaufgaben mit Lösungen der Jahrgänge 2009-2015.', price: '11.80', reduced_price: '10', year: '2016', image: '/assets/images/books/Bio_2016.jpg', weight: '0'
Product.create! title: 'Formelsammlung Technik', subtitle: 'für Technische Physik', description: 'Prüfungsaufgaben mit Lösungen der Jahrgänge 2009-2015.', price: '3.80', reduced_price: '3', year: '2016', weight: '0'
Product.create! title: 'Mathematik Vorbereitungskurs', subtitle: 'Vorbereitungskurs: zum erfolgreichen Start im Berufskolleg', description: 'Prüfungsaufgaben mit Lösungen der Jahrgänge 2009-2015.', price: '11.80', reduced_price: '10', year: '2016', weight: '0'


Product.create! title: 'Mathe', subtitle: 'Mit allen Pflicht- und allen Wahlthemen', description: 'Prüfungsaufgaben mit Lösungen der Jahrgänge 2009-2015.', price: '13.80', reduced_price: '12', year: '2016', image: '/assets/images/books/Mathe_alle_2016.jpg', weight: '0'
Product.create! title: 'Mathe', subtitle: 'Mit allen Pflicht- und dem Wahlthema Vektorielle Geometrie (Afg 4)', description: 'Prüfungsaufgaben mit Lösungen der Jahrgänge 2009-2015.', price: '9.80', reduced_price: '8', year: '2016', image: '/assets/images/books/Mathe_1-4_2016.jpg', weight: '0'
Product.create! title: 'Mathe', subtitle: 'Mit allen Pflicht- und dem Wahlthema Wirtschaftliche Anwendungen (Afg 5)', description: 'Die Pflichtthemen sind  in einem Buch und die Wahlthemen in einem separaten Heft', price: '9.80', reduced_price: '8', year: '2016', image: '/assets/images/books/Mathe_5_2016.jpg', weight: '0'
Product.create! title: 'Mathe', subtitle: 'Mit allen Pflicht- und dem Wahlthema Stochastik (Afg. 6)', description: 'Die Pflichtthemen sind  in einem Buch und die Wahlthemen in einem separaten Heft', price: '9.80', reduced_price: '8', year: '2016', image: '/assets/images/books/Mathe_6_2016.jpg', weight: '0'
Product.create! title: 'Mathe', subtitle: 'Mit allen Pflicht- und dem Wahlthema  Mathematik in der Praxis (Afg 7)', description: 'Die Pflichtthemen sind  in einem Buch und die Wahlthemen in einem separaten Heft', price: '9.80', reduced_price: '8', year: '2016', image: '/assets/images/books/Mathe_7_2016.jpg', weight: '0'
