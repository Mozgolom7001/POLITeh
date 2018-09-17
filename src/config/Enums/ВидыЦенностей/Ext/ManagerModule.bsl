﻿
// Возвращает массив видов ценностей, относящихся к операциям налогового агента по НДС.
// Параметры
//     ВключаяКомиссионныеОперации - Булево - признак необходимости включения в состав возвращаемого массива
//                                            операций реализации ценностей комитента-нерезидента.
// Возвращаемое значение: 
//     Массив - массив значений вида ПеречислениеСсылка.ВидыЦенностей.
Функция МассивВидовЦенностиНалоговыйАгент(ВключаяКомиссионныеОперации = Истина) Экспорт
	
	ВидыЦенностей = Новый Массив;
	ВидыЦенностей.Добавить(Перечисления.ВидыЦенностей.НалоговыйАгентАренда);
	ВидыЦенностей.Добавить(Перечисления.ВидыЦенностей.НалоговыйАгентИностранцы);
	ВидыЦенностей.Добавить(Перечисления.ВидыЦенностей.НалоговыйАгентРеализацияИмущества);
	
	Если ВключаяКомиссионныеОперации Тогда
		ВидыЦенностей.Добавить(Перечисления.ВидыЦенностей.НалоговыйАгентКомитент);
	КонецЕсли;
	
	Возврат ВидыЦенностей;
	
КонецФункции
