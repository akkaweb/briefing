class ScreenArgument {
  final String title;
  final String data;

  List<dynamic> arguments;

  ScreenArgument(this.title, this.data, {dynamic arguments}) {
    if (arguments != null && arguments.isNotEmpty()) {
      this.arguments = new List(arguments.length);
      arguments.forEach((element) => this.arguments.add(element));
    }
  }
}