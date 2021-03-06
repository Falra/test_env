﻿
Функция ПолучитьИмяСправочникаПоСсылке(СсылкаНаСправочник) Экспорт
	Возврат СсылкаНаСправочник.Метаданные().Имя;
КонецФункции

Функция ПолучитьКаталогПроекта(Ссылка) Экспорт
	Результат = "";
	
	Запрос = Новый Запрос;
	
	Если ТипЗнч(Ссылка) = Тип("СправочникСсылка.ПользовательскиеИстории") Тогда
		Запрос.Текст = 
		"ВЫБРАТЬ
		|	ПользовательскиеИстории.Владелец.Владелец.КаталогПроекта КАК КаталогПроекта
		|ИЗ
		|	Справочник.ПользовательскиеИстории КАК ПользовательскиеИстории
		|ГДЕ
		|	ПользовательскиеИстории.Ссылка = &Ссылка";
		
	ИначеЕсли ТипЗнч(Ссылка) = Тип("СправочникСсылка.БизнесЦели") Тогда
		Запрос.Текст = 
		"ВЫБРАТЬ
		|	БизнесЦели.Владелец.КаталогПроекта КАК КаталогПроекта
		|ИЗ
		|	Справочник.БизнесЦели КАК БизнесЦели
		|ГДЕ
		|	БизнесЦели.Ссылка = &Ссылка";

	ИначеЕсли ТипЗнч(Ссылка) = Тип("СправочникСсылка.Проекты") Тогда
		Запрос.Текст = 
		"ВЫБРАТЬ
		|	Проекты.КаталогПроекта КАК КаталогПроекта
		|ИЗ
		|	Справочник.Проекты КАК Проекты
		|ГДЕ
		|	Проекты.Ссылка = &Ссылка";

	Иначе
		Возврат Результат;
		
	КонецЕсли;
	
	Запрос.УстановитьПараметр("Ссылка", Ссылка);
	
	РезультатЗапроса = Запрос.Выполнить();
	Если Не РезультатЗапроса.Пустой() Тогда
		ВыборкаДетальныеЗаписи = РезультатЗапроса.Выбрать();
		ВыборкаДетальныеЗаписи.Следующий();
		
		Результат = ВыборкаДетальныеЗаписи.КаталогПроекта;
	КонецЕсли;
	
	Возврат Результат;
КонецФункции

Функция ПолучитьПутьКFeatureФайлу(ПользовательскаяИстория) Экспорт
	Результат = "";
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
	"ВЫБРАТЬ
	|	ПользовательскиеИстории.Владелец КАК Владелец,
	|	ПользовательскиеИстории.Заголовок + "".feature"" КАК ПутьКFeatureФайлу
	|ПОМЕСТИТЬ ВТПользовательскаяИстория
	|ИЗ
	|	Справочник.ПользовательскиеИстории КАК ПользовательскиеИстории
	|ГДЕ
	|	ПользовательскиеИстории.Ссылка = &Ссылка
	|
	|ИНДЕКСИРОВАТЬ ПО
	|	Владелец
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	ЦелиПроекта.Владелец КАК Владелец,
	|	ЦелиПроекта.Заголовок + ""\"" + ВТПользовательскаяИстория.ПутьКFeatureФайлу КАК ПутьКFeatureФайлу
	|ПОМЕСТИТЬ ВТЦелиПроекта
	|ИЗ
	|	ВТПользовательскаяИстория КАК ВТПользовательскаяИстория
	|		ЛЕВОЕ СОЕДИНЕНИЕ Справочник.БизнесЦелиПроекта КАК ЦелиПроекта
	|		ПО ВТПользовательскаяИстория.Владелец = ЦелиПроекта.Ссылка
	|
	|ИНДЕКСИРОВАТЬ ПО
	|	Владелец
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	Проекты.КаталогПроекта + ""\features\"" + ВТЦелиПроекта.ПутьКFeatureФайлу КАК ПутьКFeatureФайлу
	|ИЗ
	|	ВТЦелиПроекта КАК ВТЦелиПроекта
	|		ЛЕВОЕ СОЕДИНЕНИЕ Справочник.Проекты КАК Проекты
	|		ПО ВТЦелиПроекта.Владелец = Проекты.Ссылка";
	
	Запрос.УстановитьПараметр("Ссылка", ПользовательскаяИстория);
	
	РезультатЗапроса = Запрос.Выполнить();
	Если Не РезультатЗапроса.Пустой() Тогда
		ВыборкаДетальныеЗаписи = РезультатЗапроса.Выбрать();
		ВыборкаДетальныеЗаписи.Следующий();
		
		Результат = ВыборкаДетальныеЗаписи.ПутьКFeatureФайлу;
	КонецЕсли;
	
	Возврат Результат;
КонецФункции

Функция ПолучитьЗначениеРеквизита(ВидОбъекта, ИмяОбъекта, Ссылка, ИмяРеквизита) Экспорт
	Результат = Неопределено;
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
	"ВЫБРАТЬ
	|	ТаблицаБазыДанных." + ИмяРеквизита + " КАК Значение
	|ИЗ
	|	" + ВидОбъекта + "." + ИмяОбъекта + " КАК ТаблицаБазыДанных
	|ГДЕ
	|	ТаблицаБазыДанных.Ссылка = &Ссылка";
	
	Запрос.УстановитьПараметр("Ссылка", Ссылка);
	
	РезультатЗапроса = Запрос.Выполнить();
	Если Не РезультатЗапроса.Пустой() Тогда
		ВыборкаДетальныеЗаписи = РезультатЗапроса.Выбрать();
		ВыборкаДетальныеЗаписи.Следующий();
		
		Результат = ВыборкаДетальныеЗаписи.Значение;
	КонецЕсли;
	
	Возврат Результат;
КонецФункции

Функция ОбернутьВКавычки(Знач Строка) Экспорт
	Если Лев(Строка, 1) = """" и Прав(Строка, 1) = """" Тогда
		Возврат Строка;
	Иначе
		Возврат """" + Строка + """";
	КонецЕсли;
КонецФункции
