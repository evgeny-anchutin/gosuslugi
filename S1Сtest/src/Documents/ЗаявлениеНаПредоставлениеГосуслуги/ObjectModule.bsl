
Процедура ОбработкаЗаполнения(ДанныеЗаполнения, ТекстЗаполнения, СтандартнаяОбработка)
	
	Ответственный = ПараметрыСеанса.ТекущийПользователь;
	
КонецПроцедуры

Процедура ОбработкаПроведения(Отказ, РежимПроведения)
	
	// Запускаем бизнес-процесс, если он еще не запущен
	
	Если Не Отказ Тогда
		
		Запрос = Новый Запрос;
		Запрос.УстановитьПараметр("Заявление", Ссылка);
		Запрос.Текст =
		"ВЫБРАТЬ
		|	ПредоставлениеГосуслуги.Ссылка КАК БизнесПроцесс,
		|	ПредоставлениеГосуслуги.Стартован КАК Стартован
		|ИЗ
		|	БизнесПроцесс.ПредоставлениеГосуслуги КАК ПредоставлениеГосуслуги
		|ГДЕ
		|	ПредоставлениеГосуслуги.ЗаявлениеНаПредоставлениеГосуслуги = &Заявление";
		Выборка = Запрос.Выполнить().Выбрать();
		Если Выборка.Следующий() Тогда
			Если Не Выборка.Стартован Тогда
				БизнесПроцессОбъект = Выборка.БизнесПроцесс.ПолучитьОбъект();
				БизнесПроцессОбъект.Старт();
			КонецЕсли;
		Иначе
			
			// Создаем
			БизнесПроцессОбъект = БизнесПроцессы.ПредоставлениеГосуслуги.СоздатьБизнесПроцесс();
			БизнесПроцессОбъект.Заполнить(Ссылка);
			БизнесПроцессОбъект.Записать();
			
			БизнесПроцессОбъект.Старт();
			
		КонецЕсли;
	
	КонецЕсли;
	
КонецПроцедуры

Процедура ПередЗаписью(Отказ, РежимЗаписи, РежимПроведения)
	
	// Определяем / создаем получателя
	
	Если РежимЗаписи = РежимЗаписиДокумента.Проведение Тогда
		
		Если КатегорияПолучателя = Перечисления.КатегорияПолучателя.ФизическоеЛицо Тогда
			
			ФИО = Документы.ЗаявлениеНаПредоставлениеГосуслуги.ЗначениеПоляЗаявления(
				ЭтотОбъект, ПланыВидовХарактеристик.ВидПоляЗаявления.ФИО);
			ДатаРождения = Документы.ЗаявлениеНаПредоставлениеГосуслуги.ЗначениеПоляЗаявления(
				ЭтотОбъект, ПланыВидовХарактеристик.ВидПоляЗаявления.ДатаРождения);
			ПаспортныеДанные = Документы.ЗаявлениеНаПредоставлениеГосуслуги.ЗначениеПоляЗаявления(
				ЭтотОбъект, ПланыВидовХарактеристик.ВидПоляЗаявления.ПаспортныеДанные);
				
			Запрос = Новый Запрос;
			Запрос.УстановитьПараметр("ФИО", ФИО);
			Запрос.УстановитьПараметр("ДатаРождения", ДатаРождения);
			Запрос.УстановитьПараметр("ПаспортныеДанные", ПаспортныеДанные);
			Запрос.Текст =
			"ВЫБРАТЬ
			|	ФизическиеЛица.Ссылка КАК ФизическоеЛицо
			|ИЗ
			|	Справочник.ФизическиеЛица КАК ФизическиеЛица
			|ГДЕ
			|	ФизическиеЛица.Наименование = &ФИО
			|	И ФизическиеЛица.ДатаРождения = &ДатаРождения
			|	И ФизическиеЛица.ПаспортныеДанные = &ПаспортныеДанные";
			Выборка = Запрос.Выполнить().Выбрать();
			Если Выборка.Следующий() Тогда
				Получатель = Выборка.ФизическоеЛицо;
			Иначе
				
				// Создаем
				ФизическоеЛицоОбъект = Справочники.ФизическиеЛица.СоздатьЭлемент();
				ФизическоеЛицоОбъект.Наименование = ФИО;
				ФизическоеЛицоОбъект.ДатаРождения = ДатаРождения;
				ФизическоеЛицоОбъект.ПаспортныеДанные = ПаспортныеДанные;
				ФизическоеЛицоОбъект.Записать();
				Получатель = ФизическоеЛицоОбъект.Ссылка;
				
			КонецЕсли;
			
		ИначеЕсли КатегорияПолучателя = Перечисления.КатегорияПолучателя.ЮридическоеЛицо Тогда
			
			НаименованиеОрганизации = Документы.ЗаявлениеНаПредоставлениеГосуслуги.ЗначениеПоляЗаявления(
				ЭтотОбъект, ПланыВидовХарактеристик.ВидПоляЗаявления.НаименованиеОрганизации);
			РеквизитыОрганизации = Документы.ЗаявлениеНаПредоставлениеГосуслуги.ЗначениеПоляЗаявления(
				ЭтотОбъект, ПланыВидовХарактеристик.ВидПоляЗаявления.РеквизитыОрганизации);
				
			Запрос = Новый Запрос;
			Запрос.УстановитьПараметр("НаименованиеОрганизации", НаименованиеОрганизации);
			Запрос.УстановитьПараметр("РеквизитыОрганизации", РеквизитыОрганизации);
			Запрос.Текст =
			"ВЫБРАТЬ
			|	ЮридическиеЛица.Ссылка КАК Ссылка
			|ИЗ
			|	Справочник.ЮридическиеЛица КАК ЮридическиеЛица
			|ГДЕ
			|	ЮридическиеЛица.Наименование = &НаименованиеОрганизации
			|	И ЮридическиеЛица.Реквизиты = &РеквизитыОрганизации";
			Выборка = Запрос.Выполнить().Выбрать();
			Если Выборка.Следующий() Тогда
				Получатель = Выборка.ФизическоеЛицо;
			Иначе
				
				// Создаем
				ЮридическоеЛицоОбъект = Справочники.ЮридическиеЛица.СоздатьЭлемент();
				ЮридическоеЛицоОбъект.Наименование = НаименованиеОрганизации;
				ЮридическоеЛицоОбъект.Реквизиты = РеквизитыОрганизации;
				ЮридическоеЛицоОбъект.Записать();
				Получатель = ЮридическоеЛицоОбъект.Ссылка;
				
			КонецЕсли;
			
		КонецЕсли;
		
	КонецЕсли;
	
КонецПроцедуры
