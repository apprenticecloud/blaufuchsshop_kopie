class InvoicePdf < Prawn::Document

  include ActionView::Helpers::NumberHelper

  def initialize(orders)
    # Registering a TTF font
    font_families.update("Arial" => {
      :normal => "lib/fonts/Arial.ttf",
      :italic => "lib/fonts/Arial Italic.ttf",
      :bold => "lib/fonts/Arial Bold.ttf",
    })

    @orders = orders
    super(
      :page_size => "A4",
      :margin => [0.mm, 60.mm, 0.mm, 20.mm]
    )

    # Use Arial as default Font to support UTF-8
    font "Arial"

    # stroke_axis
    if @orders.class == Order
      order = @orders

      resend_addr(order)
      address(order)
      content(order)

    else
      @orders.each do |order|

        resend_addr(order)
        address(order)
        content(order)

        if order != @orders.last
          start_new_page
        end
      end

    end
  end

  def resend_addr(order)
    text_box("Blaufuchs Verlag | Sonnhalde 6 | 88699 Frickingen",
      :at => [0.mm, 252.mm],
      :width => 80.mm,
      :height => 5.mm,
      :align => :left,
      :size => 8.pt,
      :font => "Times-Roman"
    )
  end

  def address(order)
    order_weight = weight(order)

    text_box(%{
        #{order_weight < Constant.buechersendung ? 'BÜCHERSENDUNG' : ''}
        #{order.deliver_to_school ? order.school.name : ''}
        #{order.recipient}
        #{order.shipping_address.street_address}
        #{order.shipping_address.postal_code} #{order.shipping_address.address_locality}
      },
      :at => [0.mm, 247.mm],
      :width => 80.mm,
      :height => 40.mm,
      :align => :left,
      :size => 10.pt
    )
  end

  def content(order)
    rnumber = "RN96#{"%04d" % order.id}"
    rnday = (order.created_at + 0.days).strftime("%d.%m.%Y")
    payday = (order.created_at + 32.days).strftime("%d.%m.%Y")

    # move_cursor_to 197.mm
    # span(130.mm) do
    bounding_box([0.mm, 197.mm], :width => 130.mm, :height => 177.mm) do
      # if order.deliver_to_school
      #   font_size 10.pt
      #   text %{
      #     Ihre Rechnungsadresse}, :size => 11.pt, :style => :bold
      #   text %{#{order.given_name} #{order.family_name}
      #     #{order.invoice_address.street_address}
      #     #{order.invoice_address.postal_code} #{order.invoice_address.address_locality}
      #   }
      # end
      sum1 = 0
      order.cart.positions.each do |position|
        sum1 += position.unit_price * position.amount
      end
      if sum1 > 0
        text "Rechnung ", :size => 13.pt, :style => :bold
        move_down 2.mm
        text "#{rnumber} vom #{rnday}", :size => 11.pt, :style => :bold
        text %{Beim Überweisen bitte genau so angeben}, :size => 8.pt, :style => :italic
      else
        text "Lieferschein",  :size => 13.pt, :style => :bold
        text "#{rnumber} vom #{rnday}", :size => 11.pt, :style => :bold
      end
      font_size 10.pt
#      text %{
#        Herzlichen Dank für Ihre Bestellung beim Blaufuchs Verlag.}
      if !order.invoice_notes.blank?
        text %{
          #{order.invoice_notes}}
      end
      move_down 5.mm
      sum = 0
      list = [["Produkt", "Preis", "Menge", "Summe"]]
      order.cart.positions.each do |position|
        a = []
        a.push "<b>#{position.product.title}</b>#{position.teacher_edition? ? ' <i>Lehrerexemplar</i>' : ''}", "#{number_to_currency position.unit_price}", "#{position.amount}", "#{number_to_currency position.unit_price * position.amount}"
        sum += position.unit_price * position.amount
        list.push a
      end
      if !order.extra_price.blank?
        sum += order.extra_price
        list.push [{colspan: 3, content: "<b>#{order.extra_position}</b>"}, "#{number_to_currency order.extra_price}"]
      end
      unless sum == 0
        list.push [{colspan: 3, content: "<b>Summe netto</b>"}, "#{number_to_currency((sum / (1 + (Constant.vat_rate.to_f/100.0))))}"]
        list.push [{colspan: 3, content: "<b>Enthaltene MwSt. (#{Constant.vat_rate}%)</b>"}, "#{number_to_currency(sum - (sum / (1 + (Constant.vat_rate.to_f/100.0))))}"]
        list.push [{colspan: 3, content: "<b>Summe"}, "#{number_to_currency sum}</b>"]
        table(list, cell_style: { inline_format: true, width: 32.mm, padding: 2.mm }) do
          cells.padding = 6
          cells.borders = []
          column(0).width = 60.mm
          columns(1..3).width = 23.mm
          row(0).borders = [:bottom]
          row(0).border_width = 1.5
          row(0).font_style = :bold
          row(-3).borders = [:top]
          row(-3).column(0).align = :right
          row(-2).column(0).align = :right
          row(-1).column(0).align = :right
          column(0).align = :left       
          column(3).align = :right
          column(1).align = :right       
          column(2).align = :right
          column(2).padding = [6,6,6,12]
        end
      else
        table(list, cell_style: { inline_format: true, width: 32.mm, padding: 2.mm }) do
          cells.padding = 6
          cells.borders = []
          column(0).width = 60.mm
          columns(1..3).width = 23.mm
          row(0).borders = [:bottom]
          row(0).border_width = 1.5
          row(0).font_style = :bold
          row(-1).borders = [:bottom]
          row(-1).border_width = 1.5
          column(0).align = :left       
          column(3).align = :right
          column(1).align = :right       
          column(2).align = :right
          column(2).padding = [6,6,6,12]
        end
      end


      unless sum == 0
        # text %{Lieferung NICHT kostenlos}
        move_down 10.mm
        if order.cart.charge_reduced_prices?
          text %{Rechnungsdatum ist Lieferdatum. Zahlen Sie den Rechnungsbetrag bitte nach dem Sie das Geld von den Schülern eingesammelt haben. Sollten Ihnen dies nicht bis zum #{payday} gelingen, dann nehmen Sie nochmals Kontakt mit mir auf.}
        end
        unless order.cart.charge_reduced_prices?
          text %{Rechnungsdatum ist Lieferdatum. Zahlen Sie den Rechnungsbetrag bitte bis spätestens: #{payday}.}
        end
      end


      # transparent(0.5) { stroke_bounds }
    end
  end
end

def weight(order)
  weight = 0
  order.cart.positions.each do |position|
    weight += position.product.weight * position.amount
  end
  weight *= 1.05
end


def content2(order)

  # move_cursor_to 197.mm
  # span(130.mm) do
  bounding_box([0.mm, 197.mm], :width => 130.mm, :height => 177.mm) do
    body(order)
  end

end


def body(order)
  rnumber = "RN96#{"%04d" % order.id}"
  rnday = (order.created_at + 0.days).strftime("%d.%m.%Y")
  payday = (order.created_at + 32.days).strftime("%d.%m.%Y")


  # if order.deliver_to_school
  #   font_size 10.pt
  #   text %{
  #     Ihre Rechnungsadresse}, :size => 11.pt, :style => :bold
  #   text %{#{order.given_name} #{order.family_name}
  #     #{order.invoice_address.street_address}
  #     #{order.invoice_address.postal_code} #{order.invoice_address.address_locality}
  #   }
  # end
  text "Rechnung #{rnumber} vom #{rnday}", :size => 11.pt, :style => :bold
  font_size 10.pt
  text %{
    Herzlichen Dank für Ihre Bestellung beim Blaufuchs Verlag.}
  if !order.invoice_notes.blank?
    text %{
      #{order.invoice_notes}}
  end
  move_down 5.mm
  sum = 0
  list = [["Produkt", "Preis", "Menge", "Summe"]]
  order.cart.positions.each do |position|
    a = []
    a.push "<b>#{position.product.title}</b>#{position.teacher_edition? ? ' <i>Lehrerexemplar</i>' : ''}\n#{position.product.subtitle}", "#{number_to_currency position.unit_price}", "#{position.amount}", "#{number_to_currency position.unit_price * position.amount}"
    sum += position.unit_price * position.amount
    list.push a
  end
  if !order.extra_price.blank?
    sum += order.extra_price
    list.push [{colspan: 3, content: "<b>#{order.extra_position}</b>"}, "#{number_to_currency order.extra_price}"]
  end
  list.push [{colspan: 3, content: "<b>Summe netto</b>"}, "#{number_to_currency((sum / (1 + (Constant.vat_rate.to_f/100.0))))}"]
  list.push [{colspan: 3, content: "<b>Enthaltene MwSt. (#{Constant.vat_rate}%)</b>"}, "#{number_to_currency(sum - (sum / (1 + (Constant.vat_rate.to_f/100.0))))}"]
  list.push [{colspan: 3, content: "<b>Summe"}, "#{number_to_currency sum}</b>"]

  table(list, cell_style: { inline_format: true, width: 32.mm, padding: 2.mm }) do
    cells.padding = 6
    cells.borders = []
    column(0).width = 60.mm
    columns(1..3).width = 23.mm
    row(0).borders = [:bottom]
    row(0).border_width = 1.5
    row(0).font_style = :bold
    row(-3).borders = [:top]
    row(-3).column(0).align = :right
    row(-2).column(0).align = :right
    row(-1).column(0).align = :right
    column(3).align = :right
    column(1).align = :right
    column(2).padding = [6,6,6,12]
  end

  move_down 10.mm
  if order.cart.charge_reduced_prices?
    text %{Rechnungsdatum ist Lieferdatum. Zahlen Sie den Rechnungsbetrag bitte nach dem Sie das Geld von den Schülern eingesammelt haben. Sollten Ihnen dies nicht bis zum #{payday} gelingen, dann nehmen Sie nochmals Kontakt mit mir auf.}
  end
  unless order.cart.charge_reduced_prices?
    text %{Rechnungsdatum ist Lieferdatum. Zahlen Sie den Rechnungsbetrag bis spätestens: #{payday}.
      Zur Beachtung: Der Verkaufspreis ist knapp und ohne Mahnkosten kalkuliert. Um unsere Mahnkosten zu decken, müssen wir schon bei der ersten Mahnung 2,50 € Mahngebühren verlangen.}
  end
  text %{
    Beginnen Sie den Verwendungszweck beim Überweisen mit folgendem Text ohne Lücke: #{rnumber}

    Herzliche Grüße
    Thomas Mangold
  }

  # transparent(0.5) { stroke_bounds }
end
