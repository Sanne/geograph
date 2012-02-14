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

module CloudTm
  class Job
    include CloudTm::Model

    def destroy
      manager.getRoot.removeJobs(self)
    end

    def has_properties?(options)
      options.each do |prop, value|
        return false if send(prop) != value
      end
      true
    end

    class << self

      def find(oid)
        _oid = oid.to_i
        all.each do |job|
          return job if job.oid == _oid
        end
        return nil
      end

      def where(options = {})
        jobs = []
        all.each do |job|
          jobs << job if job.has_properties?(options)
        end
        return jobs
      end

      def create_with_root attrs = {}, &block
        create_without_root(attrs) do |instance|
          instance.set_root manager.getRoot
        end
      end

      alias_method_chain :create, :root

      def all
        manager.getRoot.getJobs
      end

    end
  end
end 