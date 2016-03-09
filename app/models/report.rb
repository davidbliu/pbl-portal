class Report < ActiveRecord::Base
	serialize :data_bins
	serialize :data_labels
	
	def self.create_points_distribution
		report = Report.where(key: 'points-distribution').first_or_create
		report.bins = []
		report.labels = []
	end

	def self.bins_and_labels(data, num_bins)
		bins = Array.new(num_bins, 0)
		max = data.max.to_f
		min = data.min.to_f
		step = (max-min)/num_bins.to_f
		labels = (0..num_bins).to_a.map{|x| (x * step).to_i}
		data.each do |d|
			i = (d/max * num_bins).to_i
			puts 'the bin was '+i.to_s
			bins[i] = bins[i] ? bins[i] + 1 : 1
		end
		return {
			bins: bins,
			labels: labels
		}
	end

	def self.get_distribution(data)
		return {
			sum: data.sum,
			mean: data.mean,
			variance: data.sample_variance,
			std: data.standard_deviation,
			median: data.median,
			max: data.max,
			min: data.min
		}
	end


	# def self.test_bins_and_labels(data = [3,2,3,4,65,63,1,2,3,4], num_bins = 10)
	# 	puts self.get_distribution(data)
	# 	bins_labels = self.bins_and_labels(data, 10)
	# 	puts bins_labels
	# 	puts bins_labels[:bins].length
	# 	puts bins_labels[:labels].length
	# end
end

module Enumerable

    def sum
      self.inject(0){|accum, i| accum + i }
    end

    def mean
      self.sum/self.length.to_f
    end

    def sample_variance
      m = self.mean
      sum = self.inject(0){|accum, i| accum +(i-m)**2 }
      sum/(self.length - 1).to_f
    end

    def standard_deviation
      return Math.sqrt(self.sample_variance)
    end
    def median
    	s = self.sort
    	return s[(self.length/2).ceil]
    end

end 