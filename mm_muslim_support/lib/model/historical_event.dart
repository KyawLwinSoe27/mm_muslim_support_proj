class HistoricalEvent {
  final String title;
  final String description;
  final String mmDescription;
  final String date;
  final String imageUrl;
  final String? hijriDate;

  HistoricalEvent ({
    required this.title,
    required this.description,
    required this.mmDescription,
    required this.date,
    required this.imageUrl,
    this.hijriDate,
  });
}

List<HistoricalEvent> historicalEvents = [
  HistoricalEvent(
    title: 'Hijrah – Migration to Medina',
    description:
    'The Prophet Muhammad ﷺ and his followers migrated from Mecca to Medina to escape persecution. This event marks the beginning of the Islamic calendar.',
    mmDescription:
    'မိုဟာမက်မြတ်စွာသောနဗီကြီး (ဆွလ္လာဟ်ဟို အလိုင်ဟေ ဝစလာမ်) နှင့် သူ၏လိုက်လံသူများသည် မက္ကာမြို့မှ မဒီနာမြို့သို့ ငြင်းပယ်မှုမှ လွတ်မြောက်ရန် ပြောင်းရွှေ့ခဲ့သည်။ ဤဖြစ်ရပ်သည် အစ္စလာမ်ဘာသာ၏ ပြက္ခဒိန်၏အစဖြစ်သည်။',
    date: '16 July 622 CE',
    imageUrl:
    'https://i0.wp.com/wajibad.wordpress.com/wp-content/uploads/2016/01/the-prophet_s-migration-to-medina2.jpg?fit=1200%2C675&ssl=1',
    hijriDate: '1 Muharram 1 AH',
  ),
  HistoricalEvent(
    title: 'Battle of Badr',
    description:
    'The first major battle in Islam where the Muslims, though outnumbered, achieved a decisive victory over the Quraysh of Mecca.',
    mmDescription:
    'အစ္စလာမ်ဘာသာတွင် ပထမဆုံးအကြီးမားဆုံးသော စစ်ပွဲဖြစ်ပြီး၊ မုဆိုးအနည်းအများရှိသော်လည်း မက်ကာမြို့ရှိ ကူရေရှ်တို့ကို အရေးပါသောအောင်မြင်မှုရရှိခဲ့သည်။',
    date: '13 March 624 CE',
    imageUrl:
    'https://upload.wikimedia.org/wikipedia/commons/thumb/2/2b/The_battle_of_Badr.png/500px-The_battle_of_Badr.png',
    hijriDate: '17 Ramadan 2 AH',
  ),
  HistoricalEvent(
    title: 'Isra and Mi\'raj – The Night Journey and Ascension',
    description:
    'The miraculous night journey and ascension of Prophet Muhammad ﷺ from Mecca to Jerusalem and then to the heavens.',
    mmDescription:
    'မိုဟာမက်မြတ်စွာသောနဗီကြီး (ဆွလ္လာဟ်ဟို အလိုင်ဟေ ဝစလာမ်) ၏ မက္ကာမြို့မှ ဂျေရုဆလင်မြို့သို့၊ ထို့နောက် ကောင်းကင်ဘုံသို့ သွားရာ ညဉ့်ခရီးနှင့် တက်လှည့်ခြင်းဖြစ်သည်။',
    date: '26 February 621 CE',
    imageUrl:
    'https://islamforchristians.com/wp-content/uploads/2014/05/1400088683.png',
    hijriDate: '27 Rajab',
  ),
  HistoricalEvent(
    title: 'Battle of Karbala',
    description:
    'The tragic battle where Husayn ibn Ali, the grandson of Prophet Muhammad ﷺ, and his companions were martyred.',
    mmDescription:
    'မိုဟာမက်မြတ်စွာသောနဗီကြီး (ဆွလ္လာဟ်ဟို အလိုင်ဟေ ဝစလာမ်) ၏ မြေးဖြစ်သူ ဟူဆိန်အစ်ဘင်အလီနှင့် သူ၏လိုက်လံသူများသည် ရန်သူများ၏လက်ထဲတွင် သေဆုံးခဲ့သော ဝမ်းနည်းဖွယ် စစ်ပွဲဖြစ်သည်။',
    date: '10 October 680 CE',
    imageUrl:
    'https://islam4u.pro/blog/wp-content/uploads/2022/08/Battle-of-Karbala-jpg.webp',
    hijriDate: '10 Muharram 61 AH',
  ),
  HistoricalEvent(
    title: 'Mawlid – Birth of Prophet Muhammad ﷺ',
    description:
    'The birth of Prophet Muhammad ﷺ, celebrated on the 12th of Rabi\' al-Awwal by many Muslims around the world.',
    mmDescription:
    'မိုဟာမက်မြတ်စွာသောနဗီကြီး (ဆွလ္လာဟ်ဟို အလိုင်ဟေ ဝစလာမ်) ၏ မွေးဖွားခြင်းကို ကမ္ဘာတစ်ဝှမ်းရှိ မုဆိုးအများစုက ရာဘီအယ်လ်အဝ်ဝယ်လ်လ ၁၂ ရက်နေ့တွင် ကျင်းပသည်။',
    date: '20 April 571 CE',
    imageUrl:
    'https://iqraonline.com/wp-content/uploads/2021/09/Mawlid-al-Nabi.png',
    hijriDate: '12 Rabi\' al-Awwal',
  ),
];
