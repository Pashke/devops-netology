# Домашнее задание к занятию "7.6. Написание собственных провайдеров для Terraform."

Бывает, что 
* общедоступная документация по терраформ ресурсам не всегда достоверна,
* в документации не хватает каких-нибудь правил валидации или неточно описаны параметры,
* понадобиться использовать провайдер без официальной документации,
* может возникнуть необходимость написать свой провайдер для системы используемой в ваших проектах.   

## Задача 1. 
Давайте потренируемся читать исходный код AWS провайдера, который можно склонировать от сюда: 
[https://github.com/hashicorp/terraform-provider-aws.git](https://github.com/hashicorp/terraform-provider-aws.git).
Просто найдите нужные ресурсы в исходном коде и ответы на вопросы станут понятны.  


1. Найдите, где перечислены все доступные `resource` и `data_source`, приложите ссылку на эти строки в коде на 
гитхабе.   
> Ссылки на строки:  
> [resourse](https://github.com/hashicorp/terraform-provider-aws/blob/724c62ba7cea20d512187d83db1ed384080a3e92/internal/provider/provider.go#L920)   
> [data_source](https://github.com/hashicorp/terraform-provider-aws/blob/724c62ba7cea20d512187d83db1ed384080a3e92/internal/provider/provider.go#L426)
2. Для создания очереди сообщений SQS используется ресурс `aws_sqs_queue` у которого есть параметр `name`. 
    * С каким другим параметром конфликтует `name`? Приложите строчку кода, в которой это указано.
> [link](https://github.com/hashicorp/terraform-provider-aws/blob/724c62ba7cea20d512187d83db1ed384080a3e92/internal/service/sqs/queue.go#L82)
> ```go
> "name": {
> 	Type:          schema.TypeString,
> 	Optional:      true,
> 	Computed:      true,
> 	ForceNew:      true,
> 	ConflictsWith: []string{"name_prefix"},
> },
> "name_prefix": {
> 	Type:          schema.TypeString,
> 	Optional:      true,
> 	Computed:      true,
> 	ForceNew:      true,
> 	ConflictsWith: []string{"name"},
> },
> ```
    * Какая максимальная длина имени? 

    * Какому регулярному выражению должно подчиняться имя?

> Если честно, пока не совсем понимаю структуру написания кода, как что и за чем идет. Не понимаю как отследить, где 
> идет валидация имени. Нашел такую валидацию, возможно она [link](https://github.com/hashicorp/terraform-provider-aws/blob/724c62ba7cea20d512187d83db1ed384080a3e92/internal/service/sqs/queue.go#L425)
> ```go
> if fifoQueue {
>     re = regexp.MustCompile(`^[a-zA-Z0-9_-]{1,75}\.fifo$`)
> } else {
>     re = regexp.MustCompile(`^[a-zA-Z0-9_-]{1,80}$`)
> }
> ```
> Длина получается 80 символов, содержит только буквы латинского алфавита, цифры, нижнее подчеркивание и тире. Для 
> очереди FIFO должна заканчиваться на `.fifo`

## Задача 2. (Не обязательно) 
В рамках вебинара и презентации мы разобрали как создать свой собственный провайдер на примере кофемашины. 
Также вот официальная документация о создании провайдера: 
[https://learn.hashicorp.com/collections/terraform/providers](https://learn.hashicorp.com/collections/terraform/providers).

1. Проделайте все шаги создания провайдера.
2. В виде результата приложение ссылку на исходный код.
3. Попробуйте скомпилировать провайдер, если получится то приложите снимок экрана с командой и результатом компиляции.

---