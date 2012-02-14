###############################################################################
###############################################################################
#
# This file is part of GeoGraph.
#
# Copyright (c) 2012 Algorithmica Srl
#
# GeoGraph is free software: you can redistribute it and/or modify
# it under the terms of the GNU Lesser General Public License as published by
# the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.
#
# GeoGraph is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU Lesser General Public License for more details.
#
# You should have received a copy of the GNU Lesser General Public License
# along with GeoGraph.  If not, see <http://www.gnu.org/licenses/>.
#
# Contact us via email at info@algorithmica.it or at
#
# Algorithmica Srl
# Vicolo di Sant'Agata 16
# 00153 Rome, Italy
#
###############################################################################
###############################################################################

module Fenix

  # In order to bypass the use of the constructor with closure, that causes problems
  # in the jruby binding.
  # Here we open the Fenix Config class and we define a method that permits to
  # valorize the same protected variables managed by the standard constructor.
  class Config
    # Accepts an hash of params, keys are instance variables of FenixConfig class
    # and values are used to valorize these variables.
    def init params
      params.each do |name, value|
        set_param(name, value)
      end
    end

    private

    # Sets an instance variable value.
    def set_param(name, value)
      # Jruby doesn't offer accessors for the protected variables.
      field = self.java_class.declared_field name
      field.accessible = true
      field.set_value Java.ruby_to_java(self), Java.ruby_to_java(value)
    end
  end
end