$qt_version = ENV["COPYQ_QT_PACKAGE_VERSION"]

class Kf5Kconfig < Formula
  desc "Configuration system"
  homepage "https://www.kde.org"
  url "https://download.kde.org/stable/frameworks/5.109/kconfig-5.109.0.tar.xz"
  sha256 "5ba91551fb682d3e1d536bc3735b56cecaa57bb698ab32dd8f662e1cc78f7ad8"
  head "https://invent.kde.org/frameworks/kconfig.git"

  depends_on "cmake" => [:build, :test]
  depends_on "ninja" => :build

  depends_on "copyq/kde/extra-cmake-modules" => [:build, :test]

  depends_on "qt"

  def install
    args = std_cmake_args
    args << "-DQT_MAJOR_VERSION=#{$qt_version}"
    args << "-DBUILD_TESTING=OFF"
    args << "-DBUILD_QCH=OFF"
    args << "-DKDE_INSTALL_QMLDIR=lib/qt#{$qt_version}/qml"
    args << "-DKDE_INSTALL_PLUGINDIR=lib/qt#{$qt_version}/plugins"
    args << "-DKDE_INSTALL_QTPLUGINDIR=lib/qt#{$qt_version}/plugins"

    args << "-DKCONFIG_USE_GUI=OFF"
    args << "-DKCONFIG_USE_DBUS=OFF"

    mkdir "build" do
      system "cmake", "-G", "Ninja", "..", *args
      system "ninja"
      system "ninja", "install"
      prefix.install "install_manifest.txt"
    end
  end

  test do
    (testpath/"CMakeLists.txt").write("find_package(KF5Config REQUIRED)")
    system "cmake", ".", "-Wno-dev"
  end
end
