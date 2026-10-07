class Canvas{
    late List<int> drawing;
    int width;
    int height;

    Canvas({required this.width, required this.height}){
      drawing = List<int>.filled(width * height, 0);
    }

    int getPixel(int x, int y){
      return drawing[y * width + x];
    }

    Map toMap(){
      return {'width' : width, 'height' : height, 'drawing' : drawing};
    }
}