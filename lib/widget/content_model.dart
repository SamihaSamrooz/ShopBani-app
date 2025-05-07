class UnboardingContent {
  String image;
  String title;
  String description;
  UnboardingContent({
    required this.description,
    required this.image,
    required this.title,
  });
}

List<UnboardingContent> contents = [
  UnboardingContent(
    description:
        "Find the perfect accessories to complement your style.\nFrom chic bags to exquisite perfumes,\nwe bring you the latest trends in fashion",
    image: "images/main.png",
    title: 'Discover Timeless Elegance\n',
  ),
  UnboardingContent(
    description:
        "We handpick premium accessories to ensure\nyou get the best quality.\nElevate your everyday look with our exclusive collection.",
    image: "images/imp1.jpg",
    title: 'Discover Timeless Elegance\n',
  ),
  UnboardingContent(
    description:
        "Enjoy a seamless shopping experience with fast delivery, secure payments,\nand easy returns. Your dream accessories are just a tap away!",
    image: "images/money.jpg",
    title: 'Shop with Ease & Confidence\n',
  ),
];
