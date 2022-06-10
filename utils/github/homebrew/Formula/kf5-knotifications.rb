$qt_version = ENV["COPYQ_QT_PACKAGE_VERSION"]

class Kf5Knotifications < Formula
  desc "Abstraction for system notifications"
  homepage "https://www.kde.org"
  url "https://download.kde.org/stable/frameworks/5.109/knotifications-5.109.0.tar.xz"
  sha256 "12b1b41c80739dcdda0cff1d81288323b8b5cb8249da45ecee4b785c604dc13d"
  head "https://invent.kde.org/frameworks/knotifications.git"

  depends_on "cmake" => [:build, :test]
  depends_on "ninja" => :build

  depends_on "copyq/kde/extra-cmake-modules" => [:build, :test]
  depends_on "copyq/kde/kf5-kconfig"
  depends_on "copyq/kde/kf5-kcoreaddons"
  depends_on "copyq/kde/kf5-kwindowsystem"
  depends_on "libcanberra"

  def install
    args = std_cmake_args

    args << "-DQT_MAJOR_VERSION=#{$qt_version}"
    args << "-DEXCLUDE_DEPRECATED_BEFORE_AND_AT=5.90.0"

    args << "-DBUILD_TESTING=OFF"
    args << "-DBUILD_QCH=OFF"
    args << "-DKDE_INSTALL_QMLDIR=lib/qt#{$qt_version}/qml"
    args << "-DKDE_INSTALL_PLUGINDIR=lib/qt#{$qt_version}/plugins"
    args << "-DKDE_INSTALL_QTPLUGINDIR=lib/qt#{$qt_version}/plugins"

    inreplace "CMakeLists.txt",
              "find_package(Qt5MacExtras ${REQUIRED_QT_VERSION} REQUIRED NO_MODULE)",
              ""
    inreplace "KF5NotificationsConfig.cmake.in",
              "find_dependency(Qt5MacExtras @REQUIRED_QT_VERSION@)",
              ""
    inreplace "src/CMakeLists.txt",
              'target_link_libraries(KF5Notifications PRIVATE Qt5::MacExtras "-framework Foundation" "-framework AppKit")',
              ""

    mkdir "build" do
      system "cmake", "-G", "Ninja", "..", *args
      system "ninja"
      system "ninja", "install"
      prefix.install "install_manifest.txt"
    end
  end

  test do
    (testpath/"CMakeLists.txt").write("find_package(KF5Notifications REQUIRED)")
    system "cmake", ".", "-Wno-dev"
  end
end
