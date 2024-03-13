class color_save {
  int alpha = 0;
  int red = 0;
  int green = 0;
  int blue = 0;

  color_save.empty() {
    this.alpha = 0;
    this.red = 0;
    this.green = 0;
    this.blue = 0;
  }

  color_save(this.alpha, this.red, this.green, this.blue);

  Map<String, dynamic> toMap() {
    return {'alpha': alpha, 'red': red, 'green': green, 'blue': blue};
  }

  @override
  String toString() {
    // TODO: implement toString
    return 'alpha = $alpha, red = $red, green = $green, blue = $blue';
  }
}
