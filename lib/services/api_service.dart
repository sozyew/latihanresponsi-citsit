
import '../models/article.dart';

// ApiService bertugas menyediakan data artikel untuk aplikasi.
//
// Pada versi ini, data disimpan secara lokal (hardcoded) di dalam
// tiga List, yaitu News, Blogs, dan Reports.
//
// Jadi, aplikasi tidak perlu memanggil API internet untuk
// menampilkan daftar artikel. Data tetap bisa ditampilkan
// ketika koneksi internet bermasalah.
class ApiService {

  // Method untuk mengambil artikel berdasarkan kategori/menu.
  //
  // Parameter menu menentukan data mana yang akan ditampilkan:
  // 'news', 'blogs', atau 'reports'.
  //
  // Future<List<Article>> berarti method ini menghasilkan
  // List berisi objek Article secara asynchronous.
  Future<List<Article>> fetchArticles(String menu) async {

    // Memberikan jeda 300 milidetik.
    // Ini hanya simulasi proses pengambilan data.
    await Future.delayed(const Duration(milliseconds: 300));

    // =========================================================
    // 1. DATA NEWS
    // =========================================================
    //
    // List<Map<String, dynamic>> digunakan untuk menyimpan
    // beberapa data artikel dalam bentuk Map.
    //
    // Setiap Map mewakili satu artikel.
    // Key seperti id, title, authors, dan summary merupakan
    // informasi yang dimiliki oleh setiap artikel.

    final List<Map<String, dynamic>> dataNews = [
      {
        "id": 40861,
        "title": "Sentinel-6B in Orbit Around Earth",
        "authors": [{"name": "NASA"}],
        "image_url": "https://assets.science.nasa.gov/dynamicimage/assets/science/psd/photojournal/pia/pia26/pia26803/PIA26803.jpg",
        "news_site": "NASA",
        "summary": "Description This artist’s concept shows the Sentinel-6B satellite, which will become the reference satellite for other missions studying sea surface height.",
        "published_at": "2026-11-16T18:52:32Z",
        "url": "https://science.nasa.gov/photojournal/sentinel-6b-in-orbit-around-earth/"
      },
      {
        "id": 40859,
        "title": "Thunderbirds in Formation",
        "authors": [{"name": "NASA"}],
        "image_url": "https://www.nasa.gov/wp-content/uploads/2026/11/11072026-ksc-max-power-airdotshow-2orig.jpg",
        "news_site": "NASA",
        "summary": "U.S. Air Force Thunderbirds fighter jets pass overhead during the agency’s MAX POWER expo and air show on Saturday, Nov. 7, 2026, at NASA’s Kennedy Space Center in Florida.",
        "published_at": "2026-11-16T18:34:47Z",
        "url": "https://www.nasa.gov/image-article/thunderbirds-in-formation/"
      },
      {
        "id": 40858,
        "title": "UK MOD Defends Satcom Resilience Amid SpaceX Starshield Concerns",
        "authors": [{"name": "European Spaceflight"}],
        "image_url": "https://europeanspaceflight.com/wp-content/uploads/2026/11/UK-MOD-Defends-Satcom-Resilience-Amid-SpaceX-Starshield-Concerns.webp",
        "news_site": "European Spaceflight",
        "summary": "The UK government has defended the resilience of its satellite-based military communications, saying that while it uses SpaceX’s Starshield service, it does not depend on any single commercial provider.",
        "published_at": "2026-11-16T17:50:24Z",
        "url": "https://europeanspaceflight.com/uk-mod-defends-satcom-resilience-amid-spacex-starshield-concerns/"
      },
      {
        "id": 40857,
        "title": "Contractor to Civil Servant: NASA Welcomes Jim Mirandy",
        "authors": [{"name": "NASA"}],
        "image_url": "https://www.nasa.gov/wp-content/uploads/2026/11/s26-013-jim-mirandy.jpg",
        "news_site": "NASA",
        "summary": "The rumble of a rocket engine might be considered a soundtrack for Jim Mirandy’s life. Mirandy has grown up with NASA as a constant presence.",
        "published_at": "2026-11-16T15:22:09Z",
        "url": "https://www.nasa.gov/centers-and-facilities/stennis/contractor-to-civil-servant-jim-mirandy/"
      },
      {
        "id": 40856,
        "title": "Analysis: Vulcan Failure Reflects an Industry in Disarray",
        "authors": [{"name": "Scarlet Dominik"}],
        "image_url": "https://i0.wp.com/www.spacescout.info/wp-content/uploads/2026/11/VULCAN1-scaled.jpg",
        "news_site": "Space Scout",
        "summary": "The industry is in desperate need of new reliable launch options to maintain space access for The United States.",
        "published_at": "2026-11-16T15:01:11Z",
        "url": "https://www.spacescout.info/2026/11/analysis-vulcan-failure-reflects-an-industry-in-disarray/"
      },
      {
        "id": 40854,
        "title": "APOD: 2026 November 16 – NGC 7129: Star Formation with Jets from Webb",
        "authors": [{"name": "NASA"}],
        "image_url": "https://assets.science.nasa.gov/dynamicimage/assets/science/missions/webb/science/2026/10/weic2620a.jpg",
        "news_site": "NASA",
        "summary": "APOD Science APOD APOD: 2026 November 16 – NGC… Today’s APOD Archive Submissions Index Search Calendar RSS Education About Discuss APOD Astronomy Picture of the Day.",
        "published_at": "2026-11-16T05:05:00Z",
        "url": "https://science.nasa.gov/image-article/apod-2026-november-16-ngc-7129-star-formation-with-jets-from-webb/"
      },
      {
        "id": 40855,
        "title": "The Last Ice on Puncak Jaya",
        "authors": [{"name": "NASA"}],
        "image_url": "https://assets.science.nasa.gov/dynamicimage/assets/science/esd/eo/images/iotd/2026/the-last-ice-on-puncak-jaya/puncakjaya_tm5_1988308.jpg",
        "news_site": "NASA",
        "summary": "Ice near the summit of the Indonesian mountain peak has shrunk to scattered patches too small to flow like glaciers.",
        "published_at": "2026-11-16T05:00:00Z",
        "url": "https://science.nasa.gov/earth/earth-observatory/the-last-ice-on-puncak-jaya/"
      },
      {
        "id": 40853,
        "title": "What’s Happening in Space Policy November 15-21, 2026",
        "authors": [{"name": "Marcia Smith"}],
        "image_url": "https://spacepolicyonline.com/wp-content/uploads/2026/11/IFT15-catch-2-300x221.jpg",
        "news_site": "SpacePolicyOnline.com",
        "summary": "Here is SpacePolicyOnline.com’s list of space policy events for the week of November 15-21, 2026 and any insight we can offer about them.",
        "published_at": "2026-11-15T23:13:57Z",
        "url": "https://spacepolicyonline.com/news/whats-happening-in-space-policy-november-15-21-2026/"
      },
      {
        "id": 40852,
        "title": "Vulcan’s Return-to-Flight Fails",
        "authors": [{"name": "Marcia Smith"}],
        "image_url": "https://pbs.twimg.com/profile_images/548027983/Website_logo_400x400.jpg",
        "news_site": "SpacePolicyOnline.com",
        "summary": "The United Launch Alliance’s eagerly awaited return-to-flight of the Vulcan rocket today did not go as planned.",
        "published_at": "2026-11-15T22:35:19Z",
        "url": "https://spacepolicyonline.com/news/vulcans-return-to-flight-fails/"
      },
      {
        "id": 40851,
        "title": "Starship Returns to its Launch Pad From Orbit",
        "authors": [{"name": "Scarlet Dominik"}],
        "image_url": "https://i0.wp.com/www.spacescout.info/wp-content/uploads/2026/11/Remotes_Logo-7-scaled.jpg",
        "news_site": "Space Scout",
        "summary": "Starship has completed its most ambitious test flight yet, with Ship 42 achieving the system’s first ever catch from orbit",
        "published_at": "2026-11-15T21:27:36Z",
        "url": "https://www.spacescout.info/2026/11/starship-returns-to-its-launch-pad-from-orbit/"
      }
    ];

    // =========================================================
    // 2. DATA BLOGS
    // =========================================================

    final List<Map<String, dynamic>> dataBlogs = [
      {
        "id": 2614,
        "title": "Biotechnology, Spacesuit Work, and Dragon Packing Start Week Aboard Station",
        "authors": [{"name": "NASA"}],
        "image_url": "https://images-assets.nasa.gov/image/iss075e0266049/iss075e0266049~large.jpg",
        "news_site": "NASA",
        "summary": "Biotechnology research including growing human lung cells and managing blood flow in space awaited the Expedition 75 crew on Monday.",
        "published_at": "2026-11-16T22:24:06Z",
        "url": "https://www.nasa.gov/blogs/spacestation/2026/11/16/biotechnology-spacesuit-work-and-dragon-packing-start-week-aboard-station/"
      },
      {
        "id": 2613,
        "title": "Botany, Biomedicine, and Cargo Ops Wrap Up Week Aboard Station",
        "authors": [{"name": "NASA"}],
        "image_url": "https://images-assets.nasa.gov/image/iss075e0254975/iss075e0254975~large.jpg",
        "news_site": "NASA",
        "summary": "Space botany and biomedical research filled the scientific schedule aboard the International Space Station at the end of the week.",
        "published_at": "2026-11-13T18:00:58Z",
        "url": "https://www.nasa.gov/blogs/spacestation/2026/11/13/botany-biomedicine-and-cargo-ops-wrap-up-week-aboard-station/"
      },
      {
        "id": 2612,
        "title": "Crew Packs Dragon with Science and Cleans Spacesuits",
        "authors": [{"name": "NASA"}],
        "image_url": "https://images-assets.nasa.gov/image/iss075e0252441/iss075e0252441~large.jpg",
        "news_site": "NASA",
        "summary": "Expedition 75 had a busy shift on Thursday primarily focusing on packing a U.S. cargo craft for its upcoming departure and cleaning a pair of spacesuits.",
        "published_at": "2026-11-12T22:07:49Z",
        "url": "https://www.nasa.gov/blogs/spacestation/2026/11/12/dragon-science-spacesuits/"
      },
      {
        "id": 2611,
        "title": "Microbiology, Spacesuits, and Cargo Mission Preps Keep Crew Busy",
        "authors": [{"name": "NASA"}],
        "image_url": "https://images-assets.nasa.gov/image/iss075e0227339/iss075e0227339~large.jpg",
        "news_site": "NASA",
        "summary": "Microbiology and spacesuit maintenance kept the Expedition 75 crew busy aboard the International Space Station on Tuesday.",
        "published_at": "2026-11-10T19:31:40Z",
        "url": "https://www.nasa.gov/blogs/spacestation/2026/11/10/microbiology-spacesuits-and-cargo-mission-preps-keep-crew-busy/"
      },
      {
        "id": 2610,
        "title": "Vulcan Leo 1: Delivering 40 satellites to space",
        "authors": [{"name": "ULA"}],
        "image_url": "https://blog.ulalaunch.com/hubfs/55617902549_1556040708_k.jpg",
        "news_site": "United Launch Alliance",
        "summary": "United Launch Alliance (ULA) plans the first of 38 heavy-lift missions for expansion of the Amazon Leo broadband constellation on Nov. 13.",
        "published_at": "2026-11-10T19:14:02Z",
        "url": "https://blog.ulalaunch.com/blog/vulcan-leo-1-delivering-40-satellites-to-space"
      },
      {
        "id": 2609,
        "title": "Spacewalk Cleanup, Biomedical Science, and Maintenance Wrap Up Week",
        "authors": [{"name": "NASA"}],
        "image_url": "https://www.nasa.gov/wp-content/uploads/2026/11/blog-useva101-110526d-1.jpg",
        "news_site": "NASA",
        "summary": "The seven Expedition 75 crew members cleaned up after a spacewalk, conducted biomedical assessments, and maintained orbital systems to wrap up a busy week aboard the International Space Station.",
        "published_at": "2026-11-06T17:48:13Z",
        "url": "https://www.nasa.gov/blogs/spacestation/2026/11/06/spacewalk-cleanup-biomedical-science-and-maintenance-wrap-up-week/"
      },
      {
        "id": 2608,
        "title": "Spacewalkers Install Final Roll-Out Solar Array",
        "authors": [{"name": "NASA"}],
        "image_url": "https://www.nasa.gov/wp-content/uploads/2026/11/blog-useva101-110526h.jpg",
        "news_site": "NASA",
        "summary": "NASA astronaut Anil Menon and CSA (Canadian Space Agency) astronaut Joshua Kutryk concluded their spacewalk outside the International Space Station at 3:35 p.m. EST.",
        "published_at": "2026-11-05T20:52:33Z",
        "url": "https://www.nasa.gov/blogs/spacestation/2026/11/05/spacewalkers-install-final-roll-out-solar-array/"
      },
      {
        "id": 2607,
        "title": "Spacewalk Begins to Install Last Roll-Out Solar Array",
        "authors": [{"name": "NASA"}],
        "image_url": "https://www.nasa.gov/wp-content/uploads/2026/11/preview-useva-101-110526c.jpg",
        "news_site": "NASA",
        "summary": "CSA (Canadian Space Agency) astronaut Joshua Kutryk and NASA astronaut Anil Menon began a spacewalk at 8:36 a.m. EST outside the International Space Station airlock.",
        "published_at": "2026-11-05T13:44:35Z",
        "url": "https://www.nasa.gov/blogs/spacestation/2026/11/05/spacewalk-begins-to-install-last-roll-out-solar-array/"
      },
      {
        "id": 2606,
        "title": "Astronauts Suit Up for Final Power Upgrade Spacewalk",
        "authors": [{"name": "NASA"}],
        "image_url": "https://www.nasa.gov/wp-content/uploads/2026/11/preview-useva-101-110526b.jpg",
        "news_site": "NASA",
        "summary": "NASA is streaming live coverage as two astronauts prepare for a spacewalk outside the International Space Station.",
        "published_at": "2026-11-05T12:02:48Z",
        "url": "https://www.nasa.gov/blogs/spacestation/2026/11/05/astronauts-suit-up-for-final-power-upgrade-spacewalk/"
      },
      {
        "id": 2605,
        "title": "Astronauts are Go for Final Power Upgrade Spacewalk",
        "authors": [{"name": "NASA"}],
        "image_url": "https://www.nasa.gov/wp-content/uploads/2026/11/preview-useva-101-110526.jpg",
        "news_site": "NASA",
        "summary": "Mission managers have given the go for two astronauts to exit the International Space Station on Thursday and install its eighth and final roll-out solar array.",
        "published_at": "2026-11-04T16:00:58Z",
        "url": "https://www.nasa.gov/blogs/spacestation/2026/11/04/astronauts-are-go-for-final-power-upgrade-spacewalk/"
      }
    ];

    // =========================================================
    // 3. DATA REPORTS
    // =========================================================
    //
    // Beberapa data Reports memiliki authors kosong ([]).
    // Karena itu, Article.fromJson menggunakan news_site
    // sebagai nama author pengganti.

    final List<Map<String, dynamic>> dataReports = [
      {
        "id": 1662,
        "title": "Starliner arrives safely back on Earth",
        "authors": [],
        "image_url": "https://boeing-jtti.s3.amazonaws.com/wp-content/uploads/2023/02/13165520/docking_with_earth_in_background_out_window.png",
        "news_site": "Boeing",
        "summary": "Boeing’s Starliner landed safely at 12:01 a.m. Eastern time on Saturday, Sept. 7 (10:01 p.m. Mountain time, on Friday, Sept. 6). After an extended stay at the International Space Station, Starliner’s reusable crew module touched down.",
        "published_at": "2024-09-07T04:14:32Z",
        "url": "https://starlinerupdates.com/starliner-arrives-safely-back-on-earth/"
      },
      {
        "id": 1661,
        "title": "Starliner heads back to Earth",
        "authors": [],
        "image_url": "https://boeing-jtti.s3.amazonaws.com/wp-content/uploads/2023/02/13165520/docking_with_earth_in_background_out_window.png",
        "news_site": "Boeing",
        "summary": "Boeing’s Starliner spacecraft undocked from the International Space Station on Friday, Sept. 6, with separation confirmed at 6:04 p.m. Eastern time.",
        "published_at": "2024-09-06T22:05:02Z",
        "url": "https://starlinerupdates.com/starliner-heads-back-to-earth/"
      },
      {
        "id": 1660,
        "title": "Boeing’s confidence remains high in Starliner’s return with crew",
        "authors": [],
        "image_url": "https://boeing-jtti.s3.amazonaws.com/wp-content/uploads/2023/02/13165520/docking_with_earth_in_background.png",
        "news_site": "Boeing",
        "summary": "Since Starliner’s Crew Flight Test (CFT) launch on June 5, Boeing and NASA have conducted extensive testing of its propulsion system in space and on the ground.",
        "published_at": "2024-08-02T23:32:46Z",
        "url": "https://starlinerupdates.com/boeings-confidence-remains-high-in-starliners-return-with-crew/"
      },
      {
        "id": 1656,
        "title": "Starliner Return to Earth Preps Underway",
        "authors": [],
        "image_url": "https://boeing-jtti.s3.amazonaws.com/wp-content/uploads/2023/02/13165520/docking_with_earth_in_background.png",
        "news_site": "Boeing",
        "summary": "Practiced, prepared, checked out, refilled, and inspected – the Starliner team is proceeding through checklists to be ready for return when a date is chosen.",
        "published_at": "2024-07-31T21:41:37Z",
        "url": "https://starlinerupdates.com/starliner-return-to-earth-preps-underway/"
      },
      {
        "id": 1655,
        "title": "Starliner Docked Hot Fire Testing Complete",
        "authors": [],
        "image_url": "https://boeing-jtti.s3.amazonaws.com/wp-content/uploads/2023/02/13165520/docking_with_earth_in_background.png",
        "news_site": "Boeing",
        "summary": "Spacecraft thrusters tested and helium system checked in second successful docked hot fire test.",
        "published_at": "2024-07-27T20:50:47Z",
        "url": "https://starlinerupdates.com/starliner-docked-hot-fire-testing-complete/"
      },
      {
        "id": 1657,
        "title": "ISS Daily Summary Report – 7/26/2024",
        "authors": [],
        "image_url": "https://upload.wikimedia.org/wikipedia/commons/8/8a/ISS_after_completion_%28as_of_June_2006%29.jpg",
        "news_site": "NASA",
        "summary": "Boeing CST-100 Crewed Flight Test (CFT): The CFT crew continued assisting the ISS crew with various audits and housekeeping.",
        "published_at": "2024-07-26T19:21:00Z",
        "url": "https://blogs.nasa.gov/stationreport/2024/07/26/iss-daily-summary-report-7-26-2024/"
      },
      {
        "id": 1658,
        "title": "ISS Daily Summary Report – 7/25/2024",
        "authors": [],
        "image_url": "https://upload.wikimedia.org/wikipedia/commons/8/8a/ISS_after_completion_%28as_of_June_2006%29.jpg",
        "news_site": "NASA",
        "summary": "Boeing CST-100 Crewed Flight Test (CFT): Today, the CFT crew performed checkouts and measurements in preparation for a future potential CFT undock.",
        "published_at": "2024-07-25T19:21:00Z",
        "url": "https://blogs.nasa.gov/stationreport/2024/07/25/iss-daily-summary-report-7-25-2024/"
      },
      {
        "id": 1654,
        "title": "Starliner team closes in on thruster issue root cause, prepares for return to Earth",
        "authors": [],
        "image_url": "https://boeing-jtti.s3.amazonaws.com/wp-content/uploads/2023/02/13165520/docking_with_earth_in_background.png",
        "news_site": "Boeing",
        "summary": "Thruster testing and inspections on the ground lead to meaningful findings prior to Starliner’s return.",
        "published_at": "2024-07-25T19:18:32Z",
        "url": "https://starlinerupdates.com/starliner-team-closes-in-on-thruster-issue-root-cause-prepares-for-return-to-earth/"
      },
      {
        "id": 1659,
        "title": "ISS Daily Summary Report – 7/24/2024",
        "authors": [],
        "image_url": "https://upload.wikimedia.org/wikipedia/commons/8/8a/ISS_after_completion_%28as_of_June_2006%29.jpg",
        "news_site": "NASA",
        "summary": "Boeing CST-100 Crewed Flight Test (CFT): Today, the ISS crew assisted the ISS crew by installing the ArgUS 1-1 Multi Payload Platform in the NanoRacks Airlock (NRAL).",
        "published_at": "2024-07-24T19:21:00Z",
        "url": "https://blogs.nasa.gov/stationreport/2024/07/24/iss-daily-summary-report-7-24-2024/"
      },
      {
        "id": 1653,
        "title": "ISS Daily Summary Report – 7/23/2024",
        "authors": [],
        "image_url": "https://upload.wikimedia.org/wikipedia/commons/8/8a/ISS_after_completion_%28as_of_June_2006%29.jpg",
        "news_site": "NASA",
        "summary": "Boeing CST-100 Crewed Flight Test (CFT): The CFT crew assisted the ISS crew by performing payload activities.",
        "published_at": "2024-07-23T15:57:00Z",
        "url": "https://blogs.nasa.gov/stationreport/2024/07/23/iss-daily-summary-report-7-23-2024/"
      }
    ];

    // =========================================================
    // 4. MEMILIH DATA BERDASARKAN MENU
    // =========================================================
    //
    // Nama menu dinormalisasi terlebih dahulu.
    // trim() menghapus spasi di awal dan akhir.
    // toLowerCase() mengubah huruf menjadi huruf kecil.
    //
    // Contoh:
    // 'News' menjadi 'news'.
    // 'BLOGS' menjadi 'blogs'.
    // ' Reports ' menjadi 'reports'.
    //
    // Dengan begitu, perbedaan huruf kapital tidak membuat
    // data gagal ditemukan.

    final normalizedMenu = menu.trim().toLowerCase();

    // Menyiapkan List kosong untuk menampung data terpilih.
    List<Map<String, dynamic>> selectedData = [];

    // Memilih daftar artikel sesuai kategori.
    if (normalizedMenu == 'news') {
      selectedData = dataNews;
    } else if (normalizedMenu == 'blogs' ||
        normalizedMenu == 'blog') {
      selectedData = dataBlogs;
    } else if (normalizedMenu == 'reports' ||
        normalizedMenu == 'report') {
      selectedData = dataReports;
    }

    // =========================================================
    // 5. MENGUBAH MAP MENJADI OBJECT ARTICLE
    // =========================================================
    //
    // Data awal masih berbentuk Map<String, dynamic>.
    // map() mengubah setiap Map menjadi object Article
    // melalui factory Article.fromJson().
    //
    // toList() mengubah hasil map menjadi List<Article>.
    //
    // normalizedMenu dikirim sebagai kategori artikel.

    return selectedData
        .map((e) => Article.fromJson(e, normalizedMenu))
        .toList();
  }
}
