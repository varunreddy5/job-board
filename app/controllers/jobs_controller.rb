class JobsController < ApplicationController
  before_action :authenticate_user!, except: [:index, :show]

  def new
    @job = current_user.jobs.build
  end

  def create
    @job = current_user.jobs.build(job_params)
    token = params[:stripeToken]
    job_type = params[:job_type]
    job_title = params[:title]
    card_brand = params[:user][:card_brand]
    card_exp_month = params[:user][:card_exp_month]
    card_exp_year  = params[:user][:card_exp_year]
    card_last4 = params[:user][:card_last4]

    charge = Stripe::Charge.create(
      :amount => 30000,
      :currency => "usd",
      :description => job_type,
      :statement_descriptor => job_title,
      :source => token
    )

    current_user.stripe_id = charge.id
    current_user.card_brand = card_brand
    current_user.card_exp_month = card_exp_month
    current_user.card_exp_year = card_exp_year
    current_user.card_last4 = card_last4
    current_user.save!
    if @job.save
      redirect_to(jobs_path)
    else
      render('new')
    end
  rescue Stripe::CardError => e
    flash[:error] = e.message
    render action: :new
  end

  def index
    if(params.has_key?(:job_type))
      @jobs = Job.where(:job_type => params[:job_type]).order("created_at desc")
    else
      @jobs = Job.all.order("created_at desc")
    end
  end

  def show
    @job = Job.find(params[:id])
  end

  def edit
    @job = Job.find(params[:id])
  end

  def update
    @job = Job.find(params[:id])
    if @job.update_attributes(job_params)
      redirect_to(job_path(@job))
    else
      render('edit')
    end
  end

  def delete
  end

  private
  def job_params
    params.require(:job).permit(:title, :description, :url, :job_type, :location, :job_author, :remote_ok, :apply_url, :avatar)
  end
end
