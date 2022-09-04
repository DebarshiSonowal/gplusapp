import 'dart:io';

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:gplusapp/Model/bigdeal.dart';
import 'package:gplusapp/Model/category_discount.dart';
import 'package:image_picker/image_picker.dart';
import 'package:introduction_screen/introduction_screen.dart';

import '../Model/big_discount.dart';
import '../Model/category.dart';
import '../Model/connect_post.dart';
import '../Model/listing.dart';
import '../Model/top_picks.dart';
import '../Navigation/Navigate.dart';

class Constance {
  static const primaryColor = Color(0xff0B4368);
  static const secondaryColor = Color(0xffFCBD14);
  static const thirdColor = Color(0xffD03830);
  static const forthColor = Color(0xff001f34);
  static const logoIcon = 'assets/images/logo.png';
  static var listPagesViewModel = [
    PageViewModel(
      title: "GPlus",
      body:
          "Here you can write the description of the page, to explain someting...",
      image: const Center(child: Icon(Icons.android)),
      footer: ElevatedButton(
        onPressed: () {
          // On button presed
        },
        child: const Text("Let's Go !"),
      ),
    ),
    PageViewModel(
      title: "GPlus",
      body:
          "Here you can write the description  of the page 2, to explain someting...",
      image: const Center(child: Icon(Icons.android)),
      footer: ElevatedButton(
        onPressed: () {
          // On button presed
        },
        child: const Text("Let's Go !"),
      ),
    ),
    PageViewModel(
      title: "GPlus",
      body:
          "Here you can write the description  of the page 2, to explain someting...",
      image: const Center(child: Icon(Icons.android)),
      footer: ElevatedButton(
        onPressed: () {
          Navigation.instance.navigate('/login');
        },
        child: const Text("Let's Go !"),
      ),
    ),
  ];
  static var geo = [
    'Guwahati',
    'Assam',
    'Northeast',
    'India',
    'International',
    'Sports'
  ];
  static var topical = [
    'Bollywood',
    'Politics',
    'Education',
    'Sports',
    'Ipsum',
    'Lorem',
  ];

  static List<BigDiscount> discounts = [
    BigDiscount('Subway', 'RGB road, Zoo tiniali', FontAwesomeIcons.subway),
    BigDiscount('Burger King', 'RGB road, near AIDC', FontAwesomeIcons.burger),
    BigDiscount(
        'Soup Kitchen', 'RGB road, near AIDC', FontAwesomeIcons.bowlFood),
    BigDiscount('Subway', 'RGB road, Zoo tiniali', FontAwesomeIcons.subway),
    BigDiscount('Burger King', 'RGB road, near AIDC', FontAwesomeIcons.burger),
    BigDiscount(
        'Soup Kitchen', 'RGB road, near AIDC', FontAwesomeIcons.bowlFood),
  ];

  static final terms =
      'Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry\'s'
      ' standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled it to make a type specimen book.'
      ' It has survived not only five centuries, but also the leap into electronic typesetting, remaining essentially unchanged. It was popularised in the '
      '1960s with the release of Letraset sheets containing Lorem Ipsum passages. Contrary to popular belief, Lorem Ipsum is not simply random text. It has '
      'roots in a piece of classical Latin literature from 45 BC, making it over 2000 years old. Richard McClintock, a Latin professor at Hampden-Sydney College in Virginia,'
      ' looked up one of the more obscure Latin words, consectetur, from a Lorem Ipsum passage, and going through the cites of the word in classical literature, discovered the'
      ' undoubtable source. Lorem Ipsum comes from sections 1.10.32 and 1.10.33 of "de Finibus Bonorum et Malorum" (The Extremes of Good and Evil) by Cicero, written in 45 BC. '
      'This book is a treatise on the theory of ethics, very popular during the Renaissance. The first line of Lorem Ipsum, "Lorem ipsum dolor sit amet..", comes from a line in section 1.10.32.';

  static final locationList = [
    'AIDC',
    'Beltola',
    'Ganeshguri',
    'Khanapara',
    'Bhetapara',
    'Basistha',
    'Kahilipara',
    'Uzanbara',
    'Panbazar',
    'Adabari',
    'Narengi',
    'Bharalu',
    'Chandmari'
  ];

  static final sliderImages = [
    'https://images.unsplash.com/photo-1534644107580-3a4dbd494a95?ixlib=rb-1.2.1&ixid=MnwxMjA3fDB8MHxzZWFyY2h8MXx8dGVzdHxlbnwwfHwwfHw%3D&auto=format&fit=crop&w=800&q=60',
    'https://images.unsplash.com/photo-1520004434532-668416a08753?ixlib=rb-1.2.1&ixid=MnwxMjA3fDB8MHxzZWFyY2h8M3x8dGVzdHxlbnwwfHwwfHw%3D&auto=format&fit=crop&w=800&q=60',
    'https://images.unsplash.com/photo-1453733190371-0a9bedd82893?ixlib=rb-1.2.1&ixid=MnwxMjA3fDB8MHxzZWFyY2h8NHx8dGVzdHxlbnwwfHwwfHw%3D&auto=format&fit=crop&w=800&q=60',
    'https://images.unsplash.com/photo-1509869175650-a1d97972541a?ixlib=rb-1.2.1&ixid=MnwxMjA3fDB8MHxzZWFyY2h8NXx8dGVzdHxlbnwwfHwwfHw%3D&auto=format&fit=crop&w=800&q=60'
  ];
  static const kfc_offer =
      'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcStcrxmNo-nV0Cgn9kMmOo72XfiRxHC69EYgA&usqp=CAU';

  // static final topList = [
  //   TopPicks(
  //       'jafaosfoansfpnapsnfpnfpnaopfnapsnfpasnfpiasnfpsanpnfp',
  //       'ADsafaflasf asfalsflafaf',
  //       'https://images.unsplash.com/photo-1509869175650-a1d97972541a?ixlib=rb-1.2.1&ixid=MnwxMjA3fDB8MHxzZWFyY2h8NXx8dGVzdHxlbnwwfHwwfHw%3D&auto=format&fit=crop&w=800&q=60',
  //       '22-12-2022'),
  //   TopPicks(
  //       'jafaosfoansfpnapsnfpnfpnaopfnapsnfpasnfpiasnfpsanpnfp',
  //       'ADsafaflasf asfalsflafaf',
  //       'https://images.unsplash.com/photo-1509869175650-a1d97972541a?ixlib=rb-1.2.1&ixid=MnwxMjA3fDB8MHxzZWFyY2h8NXx8dGVzdHxlbnwwfHwwfHw%3D&auto=format&fit=crop&w=800&q=60',
  //       '22-12-2022'),
  //   TopPicks(
  //       'jafaosfoansfpnapsnfpnfpnaopfnapsnfpasnfpiasnfpsanpnfp',
  //       'ADsafaflasf asfalsflafaf',
  //       'https://images.unsplash.com/photo-1509869175650-a1d97972541a?ixlib=rb-1.2.1&ixid=MnwxMjA3fDB8MHxzZWFyY2h8NXx8dGVzdHxlbnwwfHwwfHw%3D&auto=format&fit=crop&w=800&q=60',
  //       '22-12-2022'),
  //   TopPicks(
  //       'jafaosfoansfpnapsnfpnfpnaopfnapsnfpasnfpiasnfpsanpnfp',
  //       'ADsafaflasf asfalsflafaf',
  //       'https://images.unsplash.com/photo-1509869175650-a1d97972541a?ixlib=rb-1.2.1&ixid=MnwxMjA3fDB8MHxzZWFyY2h8NXx8dGVzdHxlbnwwfHwwfHw%3D&auto=format&fit=crop&w=800&q=60',
  //       '22-12-2022'),
  // ];

  static final bigDeals = [
    BigDeal(
        'https://images.pexels.com/photos/1640777/pexels-photo-1640777.jpeg',
        'Subway',
        'Zoo Tiniali',
        'Flat 50% off on purchase above 299'),
    BigDeal(
        'https://images.pexels.com/photos/461198/pexels-photo-461198.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=2',
        'BurgerKing',
        'GS Road',
        'Flat 75% off on purchase above 599'),
    BigDeal(
        'https://images.pexels.com/photos/376464/pexels-photo-376464.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=2',
        'Dominos',
        'Beltola',
        'Flat 100 Rs off on purchase above 499'),
  ];

  static final categoryList = [
    Category(FontAwesomeIcons.scissors, 'Parlour'),
    Category(FontAwesomeIcons.spoon, 'Food'),
    Category(FontAwesomeIcons.videoCamera, 'Movies'),
    Category(FontAwesomeIcons.laptop, 'Electronics'),
    Category(FontAwesomeIcons.shoppingCart, 'Groceries'),
    Category(Icons.medical_information, 'Medicines'),
    Category(FontAwesomeIcons.bicycle, 'Gym'),
    Category(Icons.car_rental, 'Rental Cars'),
  ];
  static const salonImage =
      'https://images.pexels.com/photos/705255/pexels-photo-705255.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=2';

  static final pollWeek = ['Roger Federer', 'Rafael Nadal', 'Novak Djokovic'];
  static final pollValue = [60, 25, 15];

  static final categoryDiscount = [
    CategoryDiscount(
      'Flat 20% off',
      'Offer valid on all items',
    ),
    CategoryDiscount(
      'Flat 15% off',
      'Offer valid on all pedicure and hair spa packages',
    ),
  ];

  static final benifits = [
    'when an unknown printer took a galley of type and scrambled it to make a type specimen book. It has survived not only five centuries,',
    'when an unknown printer took a galley of type and scrambled it to make a type specimen book. It has survived not only five centuries,',
    'when an unknown printer took a galley of type and scrambled it to make a type specimen book. It has survived not only five centuries,',
    'when an unknown printer took a galley of type and scrambled it to make a type specimen book. It has survived not only five centuries,',
  ];

  static List<File> attachements = [];

  static List<Listing> listings = [
    Listing(
        'Tutor Wanted',
        null,
        'Contrary to popular belief, Lorem Ipsum is not simply random text. It has roots in a piece of classical Latin literature from 45 BC, making it over 2000 years old.',
        5999,
        'Rukmini Nagar, Guwahati',
        false),
    Listing(
        'Selling Bullet',
        150000,
        'Contrary to popular belief, Lorem Ipsum is not simply random text. It has roots in a piece of classical Latin literature from 45 BC, making it over 2000 years old.',
        5999,
        'Rukmini Nagar, Guwahati',
        false),
    Listing(
        'Tutor Wanted',
        null,
        'Contrary to popular belief, Lorem Ipsum is not simply random text. It has roots in a piece of classical Latin literature from 45 BC, making it over 2000 years old.',
        5999,
        'Rukmini Nagar, Guwahati',
        false),
    Listing(
        'Selling Bullet',
        150000,
        'Contrary to popular belief, Lorem Ipsum is not simply random text. It has roots in a piece of classical Latin literature from 45 BC, making it over 2000 years old.',
        5999,
        'Rukmini Nagar, Guwahati',
        false),
  ];

  static List<ConnectPost> connects = [
    ConnectPost(
      'Rashmi Saikia',
      'Contrary to popular belief, Lorem Ipsum is not simply random text.'
          ' It has roots in a piece of classical Latin literature from 45 BC, making it over 2000 years old.',
      '#rent #house',
      null,
      100,
      [
        ConnectPost(
          'John Doe',
          'It has roots in a piece of classical Latin literature from 45 BC',
          '',
          null,
          3,
          [],
        ),
        ConnectPost(
          'John Doe',
          'It has roots in a piece of classical Latin literature from 45 BC',
          '',
          null,
          3,
          [],
        ),
      ],
    ),
    ConnectPost(
      'Angshuman Sharma',
      'Contrary to popular belief, Lorem Ipsum is not simply random text.'
          ' It has roots in a piece of classical Latin literature from 45 BC, making it over 2000 years old.',
      '#gym #exercise',
      'https://image.shutterstock.com/image-photo/handsome-weightlifter-preparing-training-shallow-600w-366605333.jpg',
      100,
      [
        ConnectPost(
          'John Doe',
          'It has roots in a piece of classical Latin literature from 45 BC',
          '',
          null,
          3,
          [],
        ),
        ConnectPost(
          'John Doe',
          'It has roots in a piece of classical Latin literature from 45 BC',
          '',
          null,
          3,
          [],
        ),
      ],
    ),
  ];
}
