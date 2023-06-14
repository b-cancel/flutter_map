import 'package:flutter/widgets.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:latlong2/latlong.dart';

import 'test_utils/test_app.dart';

void main() {
  testWidgets('test fit bounds methods', (tester) async {
    final controller = MapController();
    final bounds = LatLngBounds(
      const LatLng(51, 0),
      const LatLng(52, 1),
    );
    const expectedCenter = LatLng(51.50274289405741, 0.49999999999999833);

    await tester.pumpWidget(TestApp(controller: controller));

    {
      final frameConstraint = FrameFit.bounds(bounds: bounds);
      final expectedBounds = LatLngBounds(
        const LatLng(51.00145915187144, -0.3079873797085076),
        const LatLng(52.001427481787005, 1.298485398623206),
      );
      const expectedZoom = 7.451812751543818;

      controller.fitFrame(frameConstraint);
      await tester.pump();
      final mapFrame = controller.mapFrame;
      expect(mapFrame.visibleBounds, equals(expectedBounds));
      expect(mapFrame.center, equals(expectedCenter));
      expect(mapFrame.zoom, equals(expectedZoom));
    }

    {
      final frameConstraint = FrameFit.bounds(
        bounds: bounds,
        forceIntegerZoomLevel: true,
      );

      final expectedBounds = LatLngBounds(
        const LatLng(50.819818262156545, -0.6042480468750001),
        const LatLng(52.1874047455997, 1.5930175781250002),
      );
      const expectedZoom = 7;

      controller.fitFrame(frameConstraint);
      await tester.pump();
      final mapFrame = controller.mapFrame;
      expect(mapFrame.visibleBounds, equals(expectedBounds));
      expect(mapFrame.center, equals(expectedCenter));
      expect(mapFrame.zoom, equals(expectedZoom));
    }

    {
      final frameConstraint = FrameFit.bounds(
        bounds: bounds,
        inside: true,
      );

      final expectedBounds = LatLngBounds(
        const LatLng(51.19148727133182, -6.195044477408375e-13),
        const LatLng(51.8139520195805, 0.999999999999397),
      );
      const expectedZoom = 8.135709286104404;

      controller.fitFrame(frameConstraint);
      await tester.pump();

      final mapFrame = controller.mapFrame;
      expect(mapFrame.visibleBounds, equals(expectedBounds));
      expect(mapFrame.center, equals(expectedCenter));
      expect(mapFrame.zoom, equals(expectedZoom));
    }

    {
      final frameConstraint = FrameFit.bounds(
        bounds: bounds,
        inside: true,
        forceIntegerZoomLevel: true,
      );

      final expectedBounds = LatLngBounds(
        const LatLng(51.33232774035881, 0.22521972656250003),
        const LatLng(51.67425842259517, 0.7745361328125),
      );
      const expectedZoom = 9;

      controller.fitFrame(frameConstraint);
      await tester.pump();
      final mapFrame = controller.mapFrame;
      expect(mapFrame.visibleBounds, equals(expectedBounds));
      expect(mapFrame.center, equals(expectedCenter));
      expect(mapFrame.zoom, equals(expectedZoom));
    }
  });

  testWidgets('test fit bounds methods with rotation', (tester) async {
    final controller = MapController();
    final bounds = LatLngBounds(
      const LatLng(4.214943, 33.925781),
      const LatLng(-1.362176, 29.575195),
    );

    await tester.pumpWidget(TestApp(controller: controller));

    Future<void> testFitBounds({
      required double rotation,
      required FrameFit frameConstraint,
      required LatLngBounds expectedBounds,
      required LatLng expectedCenter,
      required double expectedZoom,
    }) async {
      controller.rotate(rotation);

      controller.fitFrame(frameConstraint);
      await tester.pump();
      expect(
        controller.mapFrame.visibleBounds.northWest.latitude,
        moreOrLessEquals(expectedBounds.northWest.latitude),
      );
      expect(
        controller.mapFrame.visibleBounds.northWest.longitude,
        moreOrLessEquals(expectedBounds.northWest.longitude),
      );
      expect(
        controller.mapFrame.visibleBounds.southEast.latitude,
        moreOrLessEquals(expectedBounds.southEast.latitude),
      );
      expect(
        controller.mapFrame.visibleBounds.southEast.longitude,
        moreOrLessEquals(expectedBounds.southEast.longitude),
      );
      expect(
        controller.mapFrame.center.latitude,
        moreOrLessEquals(expectedCenter.latitude),
      );
      expect(
        controller.mapFrame.center.longitude,
        moreOrLessEquals(expectedCenter.longitude),
      );
      expect(controller.mapFrame.zoom, moreOrLessEquals(expectedZoom));
    }

    // Tests with no padding

    await testFitBounds(
      rotation: -360,
      frameConstraint: FrameFit.bounds(
        bounds: bounds,
        padding: EdgeInsets.zero,
      ),
      expectedBounds: LatLngBounds(
        const LatLng(4.220875035073316, 28.95466920920177),
        const LatLng(-1.3562295282017047, 34.53572340816548),
      ),
      expectedCenter: const LatLng(1.4280748738291353, 31.75048799999998),
      expectedZoom: 5.655171629288527,
    );
    await testFitBounds(
      rotation: -300,
      frameConstraint: FrameFit.bounds(
        bounds: bounds,
        padding: EdgeInsets.zero,
      ),
      expectedBounds: LatLngBounds(
        const LatLng(6.229878688707217, 26.943661553415026),
        const LatLng(-3.3298966942067114, 36.517625059412495),
      ),
      expectedCenter: const LatLng(1.4280748738291353, 31.75048799999998),
      expectedZoom: 5.32657729277294,
    );
    await testFitBounds(
      rotation: -240,
      frameConstraint: FrameFit.bounds(
        bounds: bounds,
        padding: EdgeInsets.zero,
      ),
      expectedBounds: LatLngBounds(
        const LatLng(6.229878688707217, 26.943661553415026),
        const LatLng(-3.3298966942067114, 36.517625059412495),
      ),
      expectedCenter: const LatLng(1.4280748738291353, 31.75048799999998),
      expectedZoom: 5.32657729277294,
    );
    await testFitBounds(
      rotation: -180,
      frameConstraint: FrameFit.bounds(
        bounds: bounds,
        padding: EdgeInsets.zero,
      ),
      expectedBounds: LatLngBounds(
        const LatLng(4.220875035073316, 28.95466920920177),
        const LatLng(-1.3562295282017047, 34.53572340816548),
      ),
      expectedCenter: const LatLng(1.4280748738291353, 31.75048799999998),
      expectedZoom: 5.655171629288527,
    );
    await testFitBounds(
      rotation: -120,
      frameConstraint: FrameFit.bounds(
        bounds: bounds,
        padding: EdgeInsets.zero,
      ),
      expectedBounds: LatLngBounds(
        const LatLng(6.2298786887073065, 26.943661553414902),
        const LatLng(-3.329896694206635, 36.517625059412374),
      ),
      expectedCenter: const LatLng(1.4280748738291353, 31.75048799999998),
      expectedZoom: 5.3265772927729405,
    );
    await testFitBounds(
      rotation: -60,
      frameConstraint: FrameFit.bounds(
        bounds: bounds,
        padding: EdgeInsets.zero,
      ),
      expectedBounds: LatLngBounds(
        const LatLng(6.2298786887073065, 26.943661553414902),
        const LatLng(-3.329896694206635, 36.517625059412374),
      ),
      expectedCenter: const LatLng(1.4280748738291353, 31.75048799999998),
      expectedZoom: 5.3265772927729405,
    );
    await testFitBounds(
      rotation: 0,
      frameConstraint: FrameFit.bounds(
        bounds: bounds,
        padding: EdgeInsets.zero,
      ),
      expectedBounds: LatLngBounds(
        const LatLng(4.220875035073316, 28.95466920920177),
        const LatLng(-1.3562295282017047, 34.53572340816548),
      ),
      expectedCenter: const LatLng(1.4280748738291353, 31.75048799999998),
      expectedZoom: 5.655171629288527,
    );
    await testFitBounds(
      rotation: 60,
      frameConstraint: FrameFit.bounds(
        bounds: bounds,
        padding: EdgeInsets.zero,
      ),
      expectedBounds: LatLngBounds(
        const LatLng(6.229878688707217, 26.943661553415026),
        const LatLng(-3.3298966942067114, 36.517625059412495),
      ),
      expectedCenter: const LatLng(1.4280748738291353, 31.75048799999998),
      expectedZoom: 5.32657729277294,
    );
    await testFitBounds(
      rotation: 120,
      frameConstraint: FrameFit.bounds(
        bounds: bounds,
        padding: EdgeInsets.zero,
      ),
      expectedBounds: LatLngBounds(
        const LatLng(6.229878688707217, 26.943661553415026),
        const LatLng(-3.3298966942067114, 36.517625059412495),
      ),
      expectedCenter: const LatLng(1.4280748738291353, 31.75048799999998),
      expectedZoom: 5.32657729277294,
    );
    await testFitBounds(
      rotation: 180,
      frameConstraint: FrameFit.bounds(
        bounds: bounds,
        padding: EdgeInsets.zero,
      ),
      expectedBounds: LatLngBounds(
        const LatLng(4.220875035073316, 28.95466920920177),
        const LatLng(-1.3562295282017047, 34.53572340816548),
      ),
      expectedCenter: const LatLng(1.4280748738291353, 31.75048799999998),
      expectedZoom: 5.655171629288527,
    );
    await testFitBounds(
      rotation: 240,
      frameConstraint: FrameFit.bounds(
        bounds: bounds,
        padding: EdgeInsets.zero,
      ),
      expectedBounds: LatLngBounds(
        const LatLng(6.229878688706365, 26.94366155341602),
        const LatLng(-3.3298966942076276, 36.51762505941353),
      ),
      expectedCenter: const LatLng(1.4280748738291607, 31.75048799999998),
      expectedZoom: 5.3265772927729325,
    );
    await testFitBounds(
      rotation: 300,
      frameConstraint: FrameFit.bounds(
        bounds: bounds,
        padding: EdgeInsets.zero,
      ),
      expectedBounds: LatLngBounds(
        const LatLng(6.229878688707217, 26.943661553415026),
        const LatLng(-3.3298966942067114, 36.517625059412495),
      ),
      expectedCenter: const LatLng(1.4280748738291353, 31.75048799999998),
      expectedZoom: 5.32657729277294,
    );
    await testFitBounds(
      rotation: 360,
      frameConstraint: FrameFit.bounds(
        bounds: bounds,
        padding: EdgeInsets.zero,
      ),
      expectedBounds: LatLngBounds(
        const LatLng(4.220875035073316, 28.95466920920177),
        const LatLng(-1.3562295282017047, 34.53572340816548),
      ),
      expectedCenter: const LatLng(1.4280748738291353, 31.75048799999998),
      expectedZoom: 5.655171629288527,
    );

    // Tests with symmetric padding

    const symmetricPadding = EdgeInsets.all(12);

    await testFitBounds(
      rotation: -360,
      frameConstraint: FrameFit.bounds(
        bounds: bounds,
        padding: symmetricPadding,
      ),
      expectedBounds: LatLngBounds(
        const LatLng(4.604066851713044, 28.560190151047802),
        const LatLng(-1.732813138431261, 34.902297195324785),
      ),
      expectedCenter: const LatLng(1.4280748738291353, 31.75048799999998),
      expectedZoom: 5.470747058151099,
    );
    await testFitBounds(
      rotation: -300,
      frameConstraint: FrameFit.bounds(
        bounds: bounds,
        padding: symmetricPadding,
      ),
      expectedBounds: LatLngBounds(
        const LatLng(6.862564855409817, 26.292484184306595),
        const LatLng(-3.997225315187129, 37.171988168394705),
      ),
      expectedCenter: const LatLng(1.4280748738291607, 31.75048799999998),
      expectedZoom: 5.142152721635503,
    );
    await testFitBounds(
      rotation: -240,
      frameConstraint: FrameFit.bounds(
        bounds: bounds,
        padding: symmetricPadding,
      ),
      expectedBounds: LatLngBounds(
        const LatLng(6.862564855410326, 26.292484184305955),
        const LatLng(-3.9972253151865824, 37.17198816839402),
      ),
      expectedCenter: const LatLng(1.4280748738291353, 31.75048799999998),
      expectedZoom: 5.142152721635507,
    );
    await testFitBounds(
      rotation: -180,
      frameConstraint: FrameFit.bounds(
        bounds: bounds,
        padding: symmetricPadding,
      ),
      expectedBounds: LatLngBounds(
        const LatLng(4.6040668517126235, 28.560190151048324),
        const LatLng(-1.7328131384316936, 34.9022971953253),
      ),
      expectedCenter: const LatLng(1.4280748738291353, 31.75048799999994),
      expectedZoom: 5.470747058151096,
    );
    await testFitBounds(
      rotation: -120,
      frameConstraint: FrameFit.bounds(
        bounds: bounds,
        padding: symmetricPadding,
      ),
      expectedBounds: LatLngBounds(
        const LatLng(6.862564855410096, 26.292484184306193),
        const LatLng(-3.997225315186811, 37.17198816839431),
      ),
      expectedCenter: const LatLng(1.4280748738291353, 31.75048799999998),
      expectedZoom: 5.142152721635505,
    );
    await testFitBounds(
      rotation: -60,
      frameConstraint: FrameFit.bounds(
        bounds: bounds,
        padding: symmetricPadding,
      ),
      expectedBounds: LatLngBounds(
        const LatLng(6.8625648554105165, 26.292484184305717),
        const LatLng(-3.9972253151863786, 37.17198816839379),
      ),
      expectedCenter: const LatLng(1.4280748738291353, 31.75048799999998),
      expectedZoom: 5.142152721635509,
    );
    await testFitBounds(
      rotation: 0,
      frameConstraint: FrameFit.bounds(
        bounds: bounds,
        padding: symmetricPadding,
      ),
      expectedBounds: LatLngBounds(
        const LatLng(4.604066851712751, 28.560190151048204),
        const LatLng(-1.732813138431579, 34.90229719532515),
      ),
      expectedCenter: const LatLng(1.4280748738291353, 31.75048799999998),
      expectedZoom: 5.470747058151097,
    );
    await testFitBounds(
      rotation: 60,
      frameConstraint: FrameFit.bounds(
        bounds: bounds,
        padding: symmetricPadding,
      ),
      expectedBounds: LatLngBounds(
        const LatLng(6.862564855410008, 26.292484184306353),
        const LatLng(-3.9972253151869386, 37.17198816839443),
      ),
      expectedCenter: const LatLng(1.4280748738291353, 31.75048799999998),
      expectedZoom: 5.1421527216355045,
    );
    await testFitBounds(
      rotation: 120,
      frameConstraint: FrameFit.bounds(
        bounds: bounds,
        padding: symmetricPadding,
      ),
      expectedBounds: LatLngBounds(
        const LatLng(6.8625648554105165, 26.292484184305717),
        const LatLng(-3.9972253151863786, 37.17198816839379),
      ),
      expectedCenter: const LatLng(1.4280748738291353, 31.75048799999998),
      expectedZoom: 5.142152721635509,
    );
    await testFitBounds(
      rotation: 180,
      frameConstraint: FrameFit.bounds(
        bounds: bounds,
        padding: symmetricPadding,
      ),
      expectedBounds: LatLngBounds(
        const LatLng(4.6040668517126235, 28.560190151048324),
        const LatLng(-1.7328131384316936, 34.9022971953253),
      ),
      expectedCenter: const LatLng(1.4280748738291353, 31.75048799999994),
      expectedZoom: 5.470747058151096,
    );
    await testFitBounds(
      rotation: 240,
      frameConstraint: FrameFit.bounds(
        bounds: bounds,
        padding: symmetricPadding,
      ),
      expectedBounds: LatLngBounds(
        const LatLng(6.862564855410008, 26.292484184306353),
        const LatLng(-3.9972253151869386, 37.17198816839443),
      ),
      expectedCenter: const LatLng(1.4280748738291353, 31.75048799999998),
      expectedZoom: 5.1421527216355045,
    );
    await testFitBounds(
      rotation: 300,
      frameConstraint: FrameFit.bounds(
        bounds: bounds,
        padding: symmetricPadding,
      ),
      expectedBounds: LatLngBounds(
        const LatLng(6.862564855411076, 26.292484184305035),
        const LatLng(-3.997225315185781, 37.171988168393064),
      ),
      expectedCenter: const LatLng(1.4280748738291353, 31.75048799999998),
      expectedZoom: 5.142152721635513,
    );
    await testFitBounds(
      rotation: 360,
      frameConstraint: FrameFit.bounds(
        bounds: bounds,
        padding: symmetricPadding,
      ),
      expectedBounds: LatLngBounds(
        const LatLng(4.604066851711988, 28.56019015104908),
        const LatLng(-1.7328131384323806, 34.902297195326106),
      ),
      expectedCenter: const LatLng(1.4280748738291607, 31.75048799999998),
      expectedZoom: 5.47074705815109,
    );

    // Tests with asymmetric padding

    const asymmetricPadding = EdgeInsets.fromLTRB(12, 12, 24, 24);

    await testFitBounds(
      rotation: -360,
      frameConstraint: FrameFit.bounds(
        bounds: bounds,
        padding: asymmetricPadding,
      ),
      expectedBounds: LatLngBounds(
        const LatLng(4.634132562246874, 28.54085445883965),
        const LatLng(-2.1664538621122844, 35.34701811611249),
      ),
      expectedCenter: const LatLng(1.2239447514276816, 31.954672909718134),
      expectedZoom: 5.368867444131886,
    );
    await testFitBounds(
      rotation: -300,
      frameConstraint: FrameFit.bounds(
        bounds: bounds,
        padding: asymmetricPadding,
      ),
      expectedBounds: LatLngBounds(
        const LatLng(7.353914452121884, 26.258676859164435),
        const LatLng(-4.297341450189851, 37.9342421103809),
      ),
      expectedCenter: const LatLng(1.5218975140385778, 32.10075495753647),
      expectedZoom: 5.040273107616291,
    );
    await testFitBounds(
      rotation: -240,
      frameConstraint: FrameFit.bounds(
        bounds: bounds,
        padding: asymmetricPadding,
      ),
      expectedBounds: LatLngBounds(
        const LatLng(7.6081448623143, 26.00226365003461),
        const LatLng(-4.041607090303907, 37.677828901251075),
      ),
      expectedCenter: const LatLng(1.7782041854790855, 31.844341748407157),
      expectedZoom: 5.0402731076162945,
    );
    await testFitBounds(
      rotation: -180,
      frameConstraint: FrameFit.bounds(
        bounds: bounds,
        padding: asymmetricPadding,
      ),
      expectedBounds: LatLngBounds(
        const LatLng(5.041046797566381, 28.132484639403017),
        const LatLng(-1.7583244079256093, 34.93864829667586),
      ),
      expectedCenter: const LatLng(1.63218686735705, 31.546303090281786),
      expectedZoom: 5.3688674441318875,
    );
    await testFitBounds(
      rotation: -120,
      frameConstraint: FrameFit.bounds(
        bounds: bounds,
        padding: asymmetricPadding,
      ),
      expectedBounds: LatLngBounds(
        const LatLng(7.184346279929569, 25.53217276663045),
        const LatLng(-4.467783700569064, 37.207738017846864),
      ),
      expectedCenter: const LatLng(1.334248403356733, 31.400221042463446),
      expectedZoom: 5.040273107616298,
    );
    await testFitBounds(
      rotation: -60,
      frameConstraint: FrameFit.bounds(
        bounds: bounds,
        padding: asymmetricPadding,
      ),
      expectedBounds: LatLngBounds(
        const LatLng(6.929875826124592, 25.788585975760196),
        const LatLng(-4.723372343263628, 37.46415122697666),
      ),
      expectedCenter: const LatLng(1.0778922142686074, 31.656634251592763),
      expectedZoom: 5.0402731076162945,
    );
    await testFitBounds(
      rotation: 0,
      frameConstraint: FrameFit.bounds(
        bounds: bounds,
        padding: asymmetricPadding,
      ),
      expectedBounds: LatLngBounds(
        const LatLng(4.63413256224709, 28.540854458839405),
        const LatLng(-2.166453862112043, 35.347018116112245),
      ),
      expectedCenter: const LatLng(1.223944751427669, 31.954672909718177),
      expectedZoom: 5.3688674441318875,
    );
    await testFitBounds(
      rotation: 60,
      frameConstraint: FrameFit.bounds(
        bounds: bounds,
        padding: asymmetricPadding,
      ),
      expectedBounds: LatLngBounds(
        const LatLng(7.353914452122737, 26.258676859163398),
        const LatLng(-4.297341450188935, 37.93424211037982),
      ),
      expectedCenter: const LatLng(1.521897514038616, 32.10075495753647),
      expectedZoom: 5.040273107616298,
    );
    await testFitBounds(
      rotation: 120,
      frameConstraint: FrameFit.bounds(
        bounds: bounds,
        padding: asymmetricPadding,
      ),
      expectedBounds: LatLngBounds(
        const LatLng(7.6081448623143, 26.00226365003461),
        const LatLng(-4.041607090303907, 37.677828901251075),
      ),
      expectedCenter: const LatLng(1.7782041854790855, 31.8443417484072),
      expectedZoom: 5.0402731076162945,
    );
    await testFitBounds(
      rotation: 180,
      frameConstraint: FrameFit.bounds(
        bounds: bounds,
        padding: asymmetricPadding,
      ),
      expectedBounds: LatLngBounds(
        const LatLng(5.041046797566381, 28.132484639403017),
        const LatLng(-1.7583244079256093, 34.93864829667586),
      ),
      expectedCenter: const LatLng(1.63218686735705, 31.546303090281786),
      expectedZoom: 5.3688674441318875,
    );
    await testFitBounds(
      rotation: 240,
      frameConstraint: FrameFit.bounds(
        bounds: bounds,
        padding: asymmetricPadding,
      ),
      expectedBounds: LatLngBounds(
        const LatLng(7.184346279929569, 25.53217276663045),
        const LatLng(-4.467783700569064, 37.207738017846864),
      ),
      expectedCenter: const LatLng(1.334248403356733, 31.40022104246349),
      expectedZoom: 5.040273107616298,
    );
    await testFitBounds(
      rotation: 300,
      frameConstraint: FrameFit.bounds(
        bounds: bounds,
        padding: asymmetricPadding,
      ),
      expectedBounds: LatLngBounds(
        const LatLng(6.929875826125113, 25.788585975759595),
        const LatLng(-4.7233723432630805, 37.46415122697602),
      ),
      expectedCenter: const LatLng(1.0778922142686453, 31.6566342515928),
      expectedZoom: 5.040273107616299,
    );
    await testFitBounds(
      rotation: 360,
      frameConstraint: FrameFit.bounds(
        bounds: bounds,
        padding: asymmetricPadding,
      ),
      expectedBounds: LatLngBounds(
        const LatLng(4.634132562246874, 28.54085445883965),
        const LatLng(-2.1664538621122844, 35.34701811611249),
      ),
      expectedCenter: const LatLng(1.2239447514276816, 31.954672909718134),
      expectedZoom: 5.368867444131886,
    );
  });

  testWidgets('test fit coordinates methods', (tester) async {
    final controller = MapController();
    const coordinates = [
      LatLng(4.214943, 33.925781),
      LatLng(3.480523, 30.844116),
      LatLng(-1.362176, 29.575195),
      LatLng(-0.999705, 33.925781),
    ];

    await tester.pumpWidget(TestApp(controller: controller));

    Future<void> testFitCoordinates({
      required double rotation,
      required FitCoordinates fitCoordinates,
      required LatLng expectedCenter,
      required double expectedZoom,
    }) async {
      controller.rotate(rotation);

      controller.fitFrame(fitCoordinates);
      await tester.pump();
      expect(
        controller.mapFrame.center.latitude,
        moreOrLessEquals(expectedCenter.latitude),
      );
      expect(
        controller.mapFrame.center.longitude,
        moreOrLessEquals(expectedCenter.longitude),
      );
      expect(controller.mapFrame.zoom, moreOrLessEquals(expectedZoom));
    }

    FitCoordinates fitCoordinates({
      EdgeInsets padding = EdgeInsets.zero,
    }) =>
        FitCoordinates(
          coordinates: coordinates,
          padding: padding,
        );

    // Tests with no padding

    await testFitCoordinates(
      rotation: 45,
      fitCoordinates: fitCoordinates(),
      expectedCenter: const LatLng(1.0175550985081283, 32.16110216543986),
      expectedZoom: 5.323677289246632,
    );
    await testFitCoordinates(
      rotation: 90,
      fitCoordinates: fitCoordinates(),
      expectedCenter: const LatLng(1.4280748738291353, 31.75048799999998),
      expectedZoom: 5.655171629288528,
    );
    await testFitCoordinates(
      rotation: 135,
      fitCoordinates: fitCoordinates(),
      expectedCenter: const LatLng(1.0175550985081538, 32.16110216543989),
      expectedZoom: 5.323677289246641,
    );
    await testFitCoordinates(
      rotation: 180,
      fitCoordinates: fitCoordinates(),
      expectedCenter: const LatLng(1.4280748738291353, 31.75048799999998),
      expectedZoom: 5.655171629288529,
    );
    await testFitCoordinates(
      rotation: 225,
      fitCoordinates: fitCoordinates(),
      expectedCenter: const LatLng(1.0175550985080901, 32.16110216543997),
      expectedZoom: 5.323677289246641,
    );
    await testFitCoordinates(
      rotation: 270,
      fitCoordinates: fitCoordinates(),
      expectedCenter: const LatLng(1.4280748738291353, 31.75048799999998),
      expectedZoom: 5.655171629288529,
    );
    await testFitCoordinates(
      rotation: 315,
      fitCoordinates: fitCoordinates(),
      expectedCenter: const LatLng(1.0175550985081538, 32.16110216543989),
      expectedZoom: 5.323677289246641,
    );
    await testFitCoordinates(
      rotation: 360,
      fitCoordinates: fitCoordinates(),
      expectedCenter: const LatLng(1.4280748738291353, 31.75048799999998),
      expectedZoom: 5.655171629288529,
    );

    // Tests with symmetric padding

    const equalPadding = EdgeInsets.all(12);

    await testFitCoordinates(
      rotation: 45,
      fitCoordinates: fitCoordinates(padding: equalPadding),
      expectedCenter: const LatLng(1.0175550985081538, 32.16110216543986),
      expectedZoom: 5.139252718109209,
    );
    await testFitCoordinates(
      rotation: 90,
      fitCoordinates: fitCoordinates(padding: equalPadding),
      expectedCenter: const LatLng(1.4280748738291353, 31.75048799999998),
      expectedZoom: 5.470747058151099,
    );
    await testFitCoordinates(
      rotation: 135,
      fitCoordinates: fitCoordinates(padding: equalPadding),
      expectedCenter: const LatLng(1.0175550985081538, 32.161102165439935),
      expectedZoom: 5.139252718109208,
    );
    await testFitCoordinates(
      rotation: 180,
      fitCoordinates: fitCoordinates(padding: equalPadding),
      expectedCenter: const LatLng(1.4280748738291353, 31.75048799999998),
      expectedZoom: 5.470747058151097,
    );
    await testFitCoordinates(
      rotation: 225,
      fitCoordinates: fitCoordinates(padding: equalPadding),
      expectedCenter: const LatLng(1.0175550985081157, 32.16110216543997),
      expectedZoom: 5.13925271810921,
    );
    await testFitCoordinates(
      rotation: 270,
      fitCoordinates: fitCoordinates(padding: equalPadding),
      expectedCenter: const LatLng(1.4280748738291353, 31.75048799999998),
      expectedZoom: 5.470747058151099,
    );
    await testFitCoordinates(
      rotation: 315,
      fitCoordinates: fitCoordinates(padding: equalPadding),
      expectedCenter: const LatLng(1.0175550985081538, 32.16110216543986),
      expectedZoom: 5.13925271810921,
    );
    await testFitCoordinates(
      rotation: 360,
      fitCoordinates: fitCoordinates(padding: equalPadding),
      expectedCenter: const LatLng(1.4280748738291353, 31.75048799999998),
      expectedZoom: 5.470747058151099,
    );

    // Tests with asymmetric padding

    const asymmetricPadding = EdgeInsets.fromLTRB(12, 12, 24, 24);

    await testFitCoordinates(
      rotation: 45,
      fitCoordinates: fitCoordinates(padding: asymmetricPadding),
      expectedCenter: const LatLng(1.0175550985081665, 32.524454855645835),
      expectedZoom: 5.037373104089995,
    );
    await testFitCoordinates(
      rotation: 90,
      fitCoordinates: fitCoordinates(padding: asymmetricPadding),
      expectedCenter: const LatLng(1.63218686735705, 31.954672909718134),
      expectedZoom: 5.36886744413189,
    );
    await testFitCoordinates(
      rotation: 135,
      fitCoordinates: fitCoordinates(padding: asymmetricPadding),
      expectedCenter: const LatLng(1.3808275978186646, 32.16110216543989),
      expectedZoom: 5.037373104089992,
    );
    await testFitCoordinates(
      rotation: 180,
      fitCoordinates: fitCoordinates(padding: asymmetricPadding),
      expectedCenter: const LatLng(1.63218686735705, 31.546303090281786),
      expectedZoom: 5.3688674441318875,
    );
    await testFitCoordinates(
      rotation: 225,
      fitCoordinates: fitCoordinates(padding: asymmetricPadding),
      expectedCenter: const LatLng(1.0175550985081283, 31.797749475233953),
      expectedZoom: 5.037373104089987,
    );
    await testFitCoordinates(
      rotation: 270,
      fitCoordinates: fitCoordinates(padding: asymmetricPadding),
      expectedCenter: const LatLng(1.2239447514276816, 31.546303090281786),
      expectedZoom: 5.368867444131882,
    );
    await testFitCoordinates(
      rotation: 315,
      fitCoordinates: fitCoordinates(padding: asymmetricPadding),
      expectedCenter: const LatLng(0.6542416853021571, 32.16110216543989),
      expectedZoom: 5.037373104089994,
    );
    await testFitCoordinates(
      rotation: 360,
      fitCoordinates: fitCoordinates(padding: asymmetricPadding),
      expectedCenter: const LatLng(1.223944751427707, 31.954672909718177),
      expectedZoom: 5.368867444131889,
    );
  });
}
