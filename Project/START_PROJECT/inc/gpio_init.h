#define sbt(reg,bit) (reg|=(1<<bit))
#define cbt(reg,bit) (reg&=~(1<<bit))
#define rbt(reg,bit) (reg&(1<<bit))
//_______PORT_IN
//_______DDR________________CR1______________CR2___________FUNCTION  
//_______0__________________0________________0_____________bez podtiyzhki,bez prerbIvanii 
//_______0__________________1________________0_____________c podtiyzhkoi,bez prerbIvanii
//_______0__________________0________________1_____________bez podtiyzhki,c prerbIvaniem 
//_______0__________________1________________1_____________c podtiyzhki,c prerbIvanii
//_______PORT_OUT
//_______DDR________________CR1______________CR2___________FUNCTION
//_______1__________________0________________0_____________otkritiy stok
//_______1__________________1________________0_____________dvuhtakthiy vihod
//_______1__________________X________________1_____________skorost' do 10MHz
//_______1__________________X _______________1_____________real'niy otkritiy stok
