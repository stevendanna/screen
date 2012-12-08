#
# Cookbook Name:: screen
# Recipe:: source
#
# Copyright (C) 2012 Allan Espinosa
# 
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
# 
#    http://www.apache.org/licenses/LICENSE-2.0
# 
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#

include_recipe "git"
include_recipe "build-essential"

basedir = File.join Chef::Config.file_cache_path, "screen"

git "screen" do
  destination basedir
  repository "http://git.savannah.gnu.org/r/screen.git"
  revision node['screen']['source']['revision']
end

source_directory = File.join basedir, "src"

execute "autoheader screen source" do
  cwd source_directory
  command "autoheader"
  not_if { File.exist? File.join(source_directory, "config.h.in") }
end

execute "autoconf screen source" do
  cwd source_directory
  command "autoconf"
  not_if { File.exist? File.join(source_directory, "configure") }
end 

prefix_dir = node['screen']['prefix_dir']

execute "configure screen" do
  cwd source_directory
  command "./configure --prefix=#{prefix_dir}"
  not_if { File.exist? File.join(source_directory, "Makefile") }
end

execute "compile screen" do
  cwd source_directory
  command "make"
  not_if { File.exist? File.join(source_directory, "screen") }
end

execute "install screen" do
  cwd source_directory
  command "make install"
  not_if { File.exist? File.join(prefix_dir, "bin", "screen") }
end
