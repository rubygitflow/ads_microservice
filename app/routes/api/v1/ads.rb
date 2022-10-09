# frozen_string_literal: true

class AdsMicroservice
  include PaginationLinks
  include Validations
  include ApiErrors

  PAGE_FIRST = 1

  hash_path("/api/v1/ads") do |r|
    r.is do
      r.get do
        # https://stackoverflow.com/questions/16937731/sinatra-kaminari-pagination-problems-with-sequel-and-postgres
        page = Integer(r.params[:page]) rescue PAGE_FIRST
        # https://sequel.jeremyevans.net/rdoc/classes/Sequel/Dataset.html
        ads = Ad.order(Sequel.desc(:updated_at))
          .select(:title, :description, :city, :user_id, :lat, :lon)
          .paginate(page.to_i, Settings.pagination.page_size)

        {data: ads.all, links: pagination_links(ads)}
     end

      r.post do
        ad_params = validate_with!(::AdParamsContract)

        error = ad_params.errors.to_hash
        if error.present?
          #  the 3-d Dry::Validation's catch
          @dry_validation_response = error 
          raise NameError
        end

        result = Ads::CreateService.call(
          ad: ad_params[:ad]
        )

        if result.success?
          response.status = 201
          {data: result.ad}
        else
          response.status = 422
          error_response(result.ad)
        end
      end
    end
  end
end
