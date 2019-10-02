
Процедура ПередВыполнением(Отказ)
	
	//Если ВидЭтапа = Перечисления.ВидыЭтаповПредоставленияГосУслуги.ВыдачаРешения Тогда
		
		// Формируем результат предоставления госуслуги
		
		УстановитьПривилегированныйРежим(Истина);
		
		РезультатОбъект = Документы.РезультатПредоставленияГосУслуги.СоздатьДокумент();
		РезультатОбъект.Дата = ТекущаяДата();
		РезультатОбъект.ВидРезультата = Перечисления.ВидыРезультатаПредоставленияГосУслуги.Разрешение;
		РезультатОбъект.ГосУслуга = БизнесПроцесс.ГосУслуга;
		РезультатОбъект.Получатель = БизнесПроцесс.Получатель;
		РезультатОбъект.Записать();
		
		БизнесПроцессОбъект = БизнесПроцесс.ПолучитьОбъект();
		БизнесПроцессОбъект.РезультатПредоставленияГосУслуги = РезультатОбъект.Ссылка;
		БизнесПроцессОбъект.Записать();
		
		УстановитьПривилегированныйРежим(Ложь);
		
	//КонецЕсли;
	
КонецПроцедуры

Процедура ПередЗаписью(Отказ)
	
	// Устанавливаем исполнителя
	
	Исполнитель = Справочники.Пользователи.НайтиПоНаименованию("Исполнитель", Истина);
	
КонецПроцедуры
