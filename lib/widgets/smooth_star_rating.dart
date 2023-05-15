import 'package:flutter/material.dart';

typedef void RatingChangeCallback(double rating);

class SmoothStarRating extends StatelessWidget {
  final int? starCount;
  final double? rating;
  final RatingChangeCallback? onRatingChanged;
  final Color? color;
  final Color? borderColor;
  final double? size;
  final bool? allowHalfRating;
  final double? spacing;

  SmoothStarRating(
      {this.starCount = 5,
      this.rating = 0.0,
      this.onRatingChanged,
      this.color,
      this.borderColor,
      this.size,
      this.spacing = 0.0,
      this.allowHalfRating = true}) {
    assert(this.rating != null);
  }

  Widget buildStar(BuildContext context, int index) {
    Icon icon;
    if (index >= rating!) {
      icon = new Icon(
        Icons.star_border,
        color: borderColor ?? Theme.of(context).primaryColor,
        size: size ?? 25.0,
      );
    } else if (index > rating! - (allowHalfRating! ? 0.5 : 1.0) &&
        index < rating!) {
      icon = new Icon(
        Icons.star_half,
        color: color ?? Theme.of(context).primaryColor,
        size: size ?? 25.0,
      );
    } else {
      icon = new Icon(
        Icons.star,
        color: color ?? Theme.of(context).primaryColor,
        size: size ?? 25.0,
      );
    }

    // ignore: unnecessary_new
    return new GestureDetector(
      onTap: () {
        if (this.onRatingChanged != null) onRatingChanged!(index + 1.0);
      },
      onHorizontalDragUpdate: (dragDetails) {
        RenderObject? box = context.findRenderObject();
        final RenderBox myRenderBox = box as RenderBox;
        final Offset offset =
            myRenderBox.globalToLocal(dragDetails.globalPosition); // no error

        var pos = box.globalToLocal(dragDetails.globalPosition);
        var i = pos.dx / size!;
        var newRating = allowHalfRating! ? i : i.round().toDouble();
        if (newRating > starCount!) {
          newRating = starCount!.toDouble();
        }
        if (newRating < 0) {
          newRating = 0.0;
        }
        // ignore: unnecessary_this
        if (this.onRatingChanged != null) onRatingChanged!(newRating);
      },
      child: icon,
    );
  }

  @override
  Widget build(BuildContext context) {
    // ignore: unnecessary_new
    return new Material(
      color: Colors.transparent,
      child: Wrap(
          alignment: WrapAlignment.start,
          spacing: spacing!,
          children:
              List.generate(starCount!, (index) => buildStar(context, index))),
    );
  }
}
